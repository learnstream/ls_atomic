class StepComponent < ActiveRecord::Base
  attr_accessible :step_id, :component_id


  belongs_to :step
  belongs_to :component

  validates :step_id, :presence => true
  validates :component_id, :presence => true
end
