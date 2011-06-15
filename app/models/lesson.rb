class Lesson < ActiveRecord::Base
  has_many :events
  belongs_to :course
  default_scope :order => 'lessons.order_number'
  validates :name, :uniqueness => { :scope => :course_id }
end
