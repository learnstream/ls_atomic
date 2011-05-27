class Step < ActiveRecord::Base
  attr_accessible :name, :text

  validates :name, :length => { :maximum => 134 }
  validates :text, :presence => true

end

