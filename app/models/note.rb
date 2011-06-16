class Note < ActiveRecord::Base
  has_many :events, :as => :playable
  validates :content, :presence => true
end
