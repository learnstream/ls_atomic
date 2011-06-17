class Note < ActiveRecord::Base
  has_many :events, :as => :playable
  accepts_nested_attributes_for :events, :allow_destroy => true
end
