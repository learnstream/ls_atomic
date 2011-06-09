class Quiz < ActiveRecord::Base
  attr_reader :component_tokens

  belongs_to :problem
  has_many :quiz_components, :dependent => :destroy
  has_many :components, :through => :quiz_components
  has_many :responses, :dependent => :destroy

  validates :problem_id, :presence => true
  validates :question, :presence => true 
  validate :answer_type_present

  def course
    problem.course
  end

  def component_tokens=(ids)
    self.component_ids = ids.split(",")
  end

  def steps
    read_attribute(:steps)
  end

  def steps=(steps)
    steps_string = ""
    steps.map{|step| steps_string << step << ","}
    steps_string.slice!(-1) unless steps_string.empty?
    write_attribute(:steps, steps_string)
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

  def answer_input
    read_attribute(:answer_input)
  end

  def answer_input=(type, options = {})
    input = {"type" => type }.to_json()
    write_attribute(:answer_input, input)
  end

  def answer_output
    read_attribute(:answer_output)
  end

  def answer_output=(type, options = {})
    output = {"type" => type }.to_json()
    write_attribute(:answer_output, output)
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
