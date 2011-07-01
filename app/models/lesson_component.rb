class LessonComponent < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :component
  belongs_to :event

  validates :lesson_id, :presence => true
  validates :component_id, :presence => true
  validates :component_id, :uniqueness => { :scope => :lesson_id }
end
