class Video < ActiveRecord::Base
  belongs_to :component
  belongs_to :step

  validates :url, :presence => true
  
end

