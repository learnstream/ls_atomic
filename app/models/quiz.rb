module Playable
  def new_event_attributes=(event_attributes)
    events.build(event_attributes)
  end

  def existing_event_attributes=(event_attributes)
    if (event_attributes && events[0])
      events[0].attributes = event_attributes
    else
      events.delete(events[0]) unless events.empty?
    end
  end

  def save_event
    events[0].save(:validate => false) unless events.empty?
  end
end

class Quiz < ActiveRecord::Base
  include Playable
  
  attr_reader :component_tokens
  attr_reader :event_token

  belongs_to :course
  has_many :quiz_components, :dependent => :destroy
  has_many :components, :through => :quiz_components
  has_many :responses, :dependent => :destroy
  has_many :events, :as => :playable, :dependent => :destroy
  has_many :answers, :dependent => :destroy

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true

  validates :question, :presence => true 
  validate :answer_type_present
  validates_associated :events

  after_update :save_event

  scope :exercises, where("in_lesson = ?", false) 
  scope :locked, lambda { |course_id, user_id| select('distinct quizzes.*, memories.user_id').where('quizzes.course_id = ?', course_id).joins(:components => :memories).where('memories.user_id = ?', user_id).merge(Memory.where('memories.views = 0')) }
  scope :unlocked, lambda { |course_id, user_id| Quiz.locked(course_id, user_id).empty? ? where("quizzes.course_id = ?", course_id) : where("quizzes.course_id = ? AND quizzes.id NOT IN (?)", course_id, Quiz.locked(course_id, user_id).all.map{ |q| q.id })}
  scope :due, lambda { |course_id, user_id| select('distinct quizzes.*, memories.user_id').where('quizzes.course_id = ?', course_id).joins(:components => :memories).where('memories.user_id = ?', user_id).merge(Memory.due_before(DateTime.now.utc)) } 

  def to_json(options = {})
    super 
  end

  def as_json(options = {})
    super["quiz"].merge({ "components_tokens" => self.component_ids.join(","),
                          "existing_event_attributes" => self.events[0].as_json["event"] })
  end

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
    if(response.answer.kind_of?(Array))
      response.answer = response.answer.join("")
    end
    
    response_answer = response.answer.downcase
   
    answers.each do |answer|
      if response_answer == answer.text.downcase
        return true
      end
    end
    return false

  end 

  def skipped_by(student)
    components.each do |cmp|
      student.memories.find_by_component_id(cmp).skip!
    end
  end

  def percent_responses_correct
    if responses.count == 0 
      return 0
    end

    (responses.correct.count / responses.count * 100).round(0)
  end

  def due_for?(user)
    components.each do |component|
      if user.memories.find_by_component_id(component).due?
        return true
      end
    end
    return false
  end

  def last_response_from(user)
    self.responses.by_user(user).first
  end

  def event_token=(ids)
    self.event_ids = ids.split(",")
  end

end
