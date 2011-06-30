class LessonComponent < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :component
  belongs_to :event
end
