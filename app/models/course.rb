class Course < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :components
  has_many :enrollments, :dependent => :destroy

  validates :name, :presence => true
end
