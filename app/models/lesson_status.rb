class LessonStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  belongs_to :event

  validates :lesson_id, :uniqueness => { :scope => :user_id }

  scope :in_course, lambda { |course_id| joins(:lesson).merge(Lesson.where(:course_id => course_id)) }

  def started?
    self.event_id != -1
  end
end
