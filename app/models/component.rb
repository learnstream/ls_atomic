class Component < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :description

  belongs_to :course
  
  validates :name, :presence => true,
                   :length => { :maximum => 134}, 
                   :uniqueness => true 
  # validates :description, :presence => true, :length => [ :maximum => 10000000}
  has_many :step_components, :dependent => :destroy
  has_many :steps, :through => :step_components

end
