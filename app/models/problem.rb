class Problem < ActiveRecord::Base
  attr_accessible :name, :statement 
 

  belongs_to :course
  has_many :steps
  validates :name, :presence => true,
                   :length => { :maximum => 134}, 
                   :uniqueness => true 

end

