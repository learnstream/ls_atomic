class Problem < ActiveRecord::Base
  attr_accessible :name, :statement, :course_id 

  belongs_to :course
  has_many :steps, :order => 'order_number ASC'

  validates :name, :presence => true,
                   :length => { :maximum => 134} 
  validates :course_id, :presence => true
end

