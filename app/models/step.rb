class Step < ActiveRecord::Base
  attr_accessible :name, :text, :order_number

  belongs_to :problem
  validates :name, :length => { :maximum => 134 }
  validates :text, :presence => true

end

