class Step < ActiveRecord::Base
  attr_accessible :name, :text, :order_number

  belongs_to :problem
  validates :name, :length => { :maximum => 134 }
  validates :text, :presence => true
  validates_inclusion_of :order_number, :in => 1..1000
end

