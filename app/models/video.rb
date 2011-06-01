class Video < ActiveRecord::Base
  attr_accessible :name, :url, :start_time, :end_time, :component_id, :description

  belongs_to :component
  belongs_to :step

  validates :url, :presence => true
  
end

