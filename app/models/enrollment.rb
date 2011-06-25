class Enrollment < ActiveRecord::Base
  attr_accessible :course_id, :user_id, :role

  belongs_to :user
  belongs_to :course

  validates :course_id, :presence => true
  validates :user_id, :presence => true
  validates :user_id, :uniqueness => { :scope => :course_id }
  validates :role, :presence => true

  after_create :remember_components
  after_create :create_lesson_statuses, :if => :student?
  before_destroy :forget_components
  
  def memories
    user.memories.in_course(course)
  end

  def student?
    role == "student"
  end

  def teacher?
    role == "teacher"
  end

  def course_completion
    total_components = course.components.count

    return 1.0 if total_components == 0

    ready_components = 0.0

    memories.each do |memory|
      ready_components += 1.0 unless memory.due?
    end

    return ready_components / total_components
  end

  private

  def remember_components
    if role == "student" 
      self.course.components.each do |component|
        self.user.remember(component)
      end
    end
  end

  def forget_components
    if role == "student"
      self.course.components.each do |component|
        self.user.forget(component)
      end
    end
  end

  def create_lesson_statuses
    course.lessons.each do |lesson|
      LessonStatus.create!(:lesson_id => lesson.id, :user_id => self.user.id)
    end
  end
end
