class Lesson < ActiveRecord::Base
  belongs_to :course
  default_scope :order => 'lessons.order_number'
end
