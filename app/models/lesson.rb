class Lesson < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :quizzes, :through => :events, 
                     :source => :playable,
                     :source_type => "Quiz"

  belongs_to :course
  has_many :lesson_statuses, :dependent => :destroy
  default_scope :order => 'lessons.order_number'
  validates :name, :uniqueness => { :scope => :course_id }

  after_create :create_lesson_statuses

  private 

  def create_lesson_statuses
    course.students.each do |student|
      LessonStatus.create!(:user_id => student.id, :lesson_id => self.id)
    end
  end
end
