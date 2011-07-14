class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_many :enrollments, :dependent => :destroy
  has_many :courses, :through => :enrollments 
  has_many :memories, :dependent => :destroy
  has_many :memory_ratings, :through => :memories
  has_many :lesson_statuses, :dependent => :destroy
  has_many :authentications, :dependent => :destroy

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::MD5
    config.logged_in_timeout = 1.year
  end

  def taught_courses
    taught_enrollments = enrollments.where(:role => "teacher")
    taught_enrollments.map { |e| e.course }
  end

  def studied_courses
    studied_enrollments = enrollments.where(:role => "student")
    studied_enrollments.map { |e| e.course }
  end

  def enrolled?(course)
    enrollments.find_by_course_id(course)
  end

  def enroll!(course)
    Enrollment.create!(:course_id => course.id, :user_id => self.id, :role => "student")
  end

  def unenroll!(course)
    enrollments.find_by_course_id(course).destroy
  end

  def enroll_as_teacher!(course)
    if enrolled?(course)
      unenroll!(course)
    end
    new_enrollment = enrollments.build(:course_id => course.id)
    new_enrollment.role = "teacher"
    new_enrollment.save!
  end

  def student?(course)
    enrollment = enrollments.find_by_course_id(course)
    enrollment and enrollment.role == "student"
  end

  def teacher?(course)
    enrollment = enrollments.find_by_course_id(course)
    enrollment and enrollment.role == "teacher"
  end
  
  def admin?
    perm == "admin"
  end
  
  def can_edit?(course)
    teacher?(course) || admin?
  end

  def remember(component)
    memories.create(:component_id => component.id) 
  end

  def forget(component)
    memory = memories.find_by_component_id(component.id)
    memory.destroy
  end

  def memories_due(course)
    memories.in_course(course).due_before(Time.now.utc)
  end

  def all_memories(course)
    memories.in_course(course)
  end

  def memories_due_with_quiz(course)
    memories_due_with_quiz = memories.joins(:component => :quizzes).merge(Quiz.unlocked(course.id, self.id).exercises).in_course(course).due_before(Time.now.utc).all
    memories_due_with_quiz.map{|m| m.id}.uniq
  end

  def number_of_memories_today(course)
    memories.reviewed_today.length + memories_due_with_quiz(course).length
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    self.name = omniauth['user_info']['name'] if name.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
end
