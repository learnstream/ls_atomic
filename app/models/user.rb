class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_many :enrollments, :dependent => :destroy

  has_many :courses, :through => :enrollments 

  has_many :memories, :dependent => :destroy

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
end
