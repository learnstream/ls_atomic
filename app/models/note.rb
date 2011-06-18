module Playable
  def new_event_attributes=(event_attributes)
    events.build(event_attributes)
  end

  def existing_event_attributes=(event_attributes)
    if event_attributes
      events[0].attributes = event_attributes
    else
      events.delete(events[0]) unless events.empty?
    end
  end

  def save_event
    events[0].save(:validate => false) unless events.empty?
  end
end

class Note < ActiveRecord::Base
  include Playable
  
  validates :content, :presence => true

  has_many :events, :as => :playable
  validates_associated :events

  after_update :save_event
end
