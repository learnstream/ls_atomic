class Problem < ActiveRecord::Base
  belongs_to :course
  has_many :steps, :order => 'order_number ASC'
  has_attached_file :image

  validates :name, :presence => true,
                   :length => { :maximum => 134} 
  validates :course_id, :presence => true
end
