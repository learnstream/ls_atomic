class LessonStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  belongs_to :event

  validates :lesson_id, :uniqueness => { :scope => :user_id }
end
