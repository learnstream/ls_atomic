class Lesson < ActiveRecord::Base
  has_many :events
  has_many :quizzes, :through => :events, 
                     :source => :playable,
                     :source_type => "Quiz"

  belongs_to :course
  default_scope :order => 'lessons.order_number'
  validates :name, :uniqueness => { :scope => :course_id }
end
