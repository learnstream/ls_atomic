class Enrollment < ActiveRecord::Base
  attr_accessible :course_id

  belongs_to :user
  belongs_to :course

  validates :user_id, :presence => true
  validates :course_id, :presence => true
  validates :role, :presence => true

  after_create :remember_components
  before_destroy :forget_components

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
end
