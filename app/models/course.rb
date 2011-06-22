class Course < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :components
  has_many :enrollments, :dependent => :destroy
  has_many :users, :through => :enrollments
  has_many :lessons
  has_many :quizzes

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

  def first_lesson_for(student)
    
    lessons.each do |lesson|
      lesson.quizzes.each do |quiz|
        quiz.components.each do |cmp|
          mem = cmp.memories.find_by_user_id(student)
          if !mem.viewed?
            return lesson
          end
        end
      end
    end

    return nil
  end
end
