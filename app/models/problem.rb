class Problem < ActiveRecord::Base
  attr_accessible :name, :statement 
 

  belongs_to :course
  has_many :steps, :order => 'order_number ASC'
  validates :name, :presence => true,
                   :length => { :maximum => 134}, 
                   :uniqueness => true 
  validates :course_id, :presence => true
end

