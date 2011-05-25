class Course < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :components

  validates :name, :presence => true
end
