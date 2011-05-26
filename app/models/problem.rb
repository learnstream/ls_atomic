class Problem < ActiveRecord::Base
  attr_accessible :name, :statement, :steps
 
  serialize :steps

  belongs_to :course

  validates :name, :presence => true,
                   :length => { :maximum => 134}, 
                   :uniqueness => true 

end

