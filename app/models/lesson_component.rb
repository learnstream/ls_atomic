class LessonComponent < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :component
  belongs_to :event

  validates :lesson_id, :presence => true
  validates :component_id, :presence => true
  validates :component_id, :uniqueness => { :scope => :lesson_id }

  after_create :unlock_memories_for_students

  def unlock_memories_for_students
    @students = self.component.course.students
    @students.each do |student|
      status = student.lesson_statuses.find_by_lesson_id(lesson)
      if(status && status.started?)
        student.memories.find_by_component_id(component).unlock!
      end
    end
  end
end
