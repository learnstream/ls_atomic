class Event < ActiveRecord::Base
  belongs_to :playable, :polymorphic => true
  belongs_to :lesson
end
