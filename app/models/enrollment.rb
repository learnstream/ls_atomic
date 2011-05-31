class Enrollment < ActiveRecord::Base
  attr_accessible :course_id

  belongs_to :user
  belongs_to :course

  validates :user_id, :presence => true
  validates :course_id, :presence => true
  validates :role, :presence => true

  def after_create
    if role == "student" 
      course.components.each do |component|
       user.remember(component)
      end
    end
  end

end
