class Note < ActiveRecord::Base
  has_many :events, :as => :playable
end
