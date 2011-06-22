class Event < ActiveRecord::Base
  belongs_to :playable, :polymorphic => true
  belongs_to :lesson

  validates :lesson_id, :presence => true

  default_scope :order => 'events.order_number'

  before_create :assign_order_number

  def assign_order_number
    self.order_number = lesson.events.count
  end
end
