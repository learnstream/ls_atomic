class Event < ActiveRecord::Base
  belongs_to :playable, :polymorphic => true
  belongs_to :lesson

  default_scope :order => 'events.order_number'
end
