class Course < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :components
  has_many :problems
  has_many :enrollments, :dependent => :destroy
  has_many :users, :through => :enrollments
  has_many :lessons

  validates :name, :presence => true

  def teacher_enrollments
    enrollments.where(:role => "teacher")
  end

  def student_enrollments
    enrollments.where(:role => "student")
  end

  def students
    student_enrollments.map { |e| e.user } 
  end

  def teachers
    teacher_enrollments.map { |e| e.user }
  end
end
