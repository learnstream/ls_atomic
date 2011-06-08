class Enrollment < ActiveRecord::Base
  attr_accessible :course_id

  belongs_to :user
  belongs_to :course

  validates :user_id, :presence => true
  validates :course_id, :presence => true
  validates :role, :presence => true

  after_create :remember_components
  before_destroy :forget_components
  
  def memories
    user.memories.in_course(course)
  end

  def remember_components
    if role == "student" 
      course.components.each do |component|
        user.remember(component)
      end
    end
  end

  def forget_components
    if role == "student"
      course.components.each do |component|
        user.forget(component)
      end
    end
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
end
