class Problem < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :course
  has_many :steps, :order => 'order_number ASC'
  has_many :quizzes
  has_attached_file :image

  validates :name, :length => { :maximum => 134} 
  validates :statement, :presence => true
  validates :course_id, :presence => true



  def to_s
   if name.blank?
     truncate(statement.reverse, :length => 80).reverse
   else
     name
   end
  end
end
