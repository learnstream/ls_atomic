class Lesson < ActiveRecord::Base

  attr_reader :component_tokens

  has_many :events, :dependent => :destroy
  has_many :quizzes, :through => :events, 
                     :source => :playable,
                     :source_type => "Quiz"
  has_many :lesson_statuses, :dependent => :destroy
  has_many :lesson_components, :dependent => :destroy
  has_many :components, :through => :lesson_components
  belongs_to :course
  default_scope :order => 'lessons.order_number'
  validates :name, :uniqueness => { :scope => :course_id }

  after_create :create_lesson_statuses

  scope :incomplete_for, lambda {|user_id| joins(:lesson_statuses).merge(LessonStatus.where(:user_id => user_id, :completed => false)) }

  def next_lesson
    self.course.lessons.where("order_number > ?", self.order_number).first
  end



  #----- added
  def component_tokens=(ids)
    self.component_ids = ids.split(",")
  end
  #---------
  private 

  def create_lesson_statuses
    course.students.each do |student|
      LessonStatus.create!(:user_id => student.id, :lesson_id => self.id)
    end
  end
end
