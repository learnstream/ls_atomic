class Step < ActiveRecord::Base
  attr_accessible :name, :text, :order_number, :problem_id, :component_tokens
  attr_reader :component_tokens

  belongs_to :problem
  has_many :step_components, :dependent => :destroy
  has_many :components, :through => :step_components
  has_many :videos

  validates :name, :length => { :maximum => 134 }
  validates :text, :presence => true
  validates_inclusion_of :order_number, :in => 1..1000

  default_scope order("order_number")
  scope :steps_up_to, lambda { |n| where("order_number < ?", n) }

  def component_tokens=(ids)
    self.component_ids = ids.split(",")
  end

  def related?(component)
    step_components.find_by_component_id(component)
  end

  def relate!(component)
    step_components.create!(:component_id => component.id)
  end

  def unrelate!(component)
    step_components.find_by_component_id(component).destroy
  end

  def as_json(options={})
    { :id => self.id, :text => self.text }
  end
end

