class Quiz < ActiveRecord::Base
  include Playable
  
  attr_reader :component_tokens

  belongs_to :course
  has_many :quiz_components, :dependent => :destroy
  has_many :components, :through => :quiz_components
  has_many :responses, :dependent => :destroy
  has_many :events, :as => :playable

  validates :question, :presence => true 
  validate :answer_type_present
  validates_associated :events

  after_update :save_event

  def component_tokens=(ids)
    self.component_ids = ids.split(",")
  end

  def answer_type
    if answer_input.nil?
      "none"
    else
      JSON.parse(answer_input)["type"] 
    end
  end

  def answer_type=(type)
  end

  def answer_type_present
    parsed_answer_input = JSON.parse(answer_input)
    errors.add(:answer_type, "must be present") if not parsed_answer_input.has_key?("type") or parsed_answer_input["type"].blank?
  end

  def check_answer(response)
    response_answer = response.answer
    if answer.downcase == response_answer.downcase
     return true
    else
     return false
    end
  end 

  def rate_components!(user, quality)
    components.each do |component|
      memory = user.memories.find_by_component_id(component)
      memory.view(quality)
    end
  end
end
