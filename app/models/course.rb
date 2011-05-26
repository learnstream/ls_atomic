class Course < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :components
  has_many :problems

  validates :name, :presence => true
end
