class Component < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :description

  #belongs_to cousre
  
  validates :name, :presence => true,
                   :length => { :maximum => 134}, 
                   :uniqueness => true 
  # validates :description, :presence => true, :length => [ :maximum => 10000000}

end