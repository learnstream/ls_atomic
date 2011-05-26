class Course < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :components
  has_many :enrollments, :dependent => :destroy
  has_many :users, :through => :enrollments

  validates :name, :presence => true

  def students
    student_enrollments = enrollments.find(:all, 
                                           :conditions => { :role => "student" })
    student_enrollments.map { |e| e.user } 
  end

  def teachers
    teacher_enrollments = enrollments.find(:all,
                                           :conditions => { :role => "teacher" })
    teacher_enrollments.map { |e| e.user }
  end
end
