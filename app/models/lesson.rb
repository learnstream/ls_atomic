class Lesson < ActiveRecord::Base
  belongs_to :course
  default_scope :order => 'lessons.order_number'
  validates :name, :uniqueness => { :scope => :course_id }
end
