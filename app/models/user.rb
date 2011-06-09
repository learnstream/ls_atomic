class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_many :enrollments, :dependent => :destroy
  has_many :courses, :through => :enrollments 
  has_many :memories, :dependent => :destroy
  has_many :memory_ratings, :through => :memories

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
    enrollments.create!(:course_id => course.id)
  end

  def unenroll!(course)
    enrollments.find_by_course_id(course).destroy
  end

  def enroll_as_teacher!(course)
    if enrolled?(course)
      unenroll!(course)
    end
    enrollments.create!(:course_id => course.id)
    enrollment = self.enrollments.find_by_course_id(course.id)
    enrollment.role = "teacher"
    enrollment.save!
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
    memories_due(course).map { |m| m.has_quiz? ? m : nil }.compact
  end

  def all_memories_with_quiz(course)
    all_memories(course).map { |m| m.has_quiz? ? m : nil }.compact
  end

  def stats(course, stime, etime)
    time_range = stime..etime
    ratings = memory_ratings.in_course(course).ratings_between(time_range)
    m = h = g = e = 0   #initializing ratings
    ratings.each { |r|
      if r.quality == 0
        m += 1
      elsif r.quality == 3
        h += 1
      elsif r.quality == 4
        g += 1
      elsif r.quality == 5
        e += 1
      end }
    return [m, h, g, e]
  end
end
