class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz

  before_create :grade_response
  before_create :handle_skip

  scope :by_user, lambda { |user_id| where(:user_id => user_id) } 

  def rate_components!(quality)
    self.has_been_rated = true
    quiz.components.each do |component|
      memory = user.memories.find_by_component_id(component)
      memory.view(quality)
    end
  end

  private

  def grade_response
    if self.status != "skipped"
      if quiz.answer_type != "self-rate" 
        if quiz.check_answer(self) 
          self.status = "correct"
        else
          self.status = "incorrect"
          rate_components!(0)
        end
      else
        self.status = ""
      end
    end
  end

  def handle_skip
    if self.status == "skipped"
      quiz.skipped_by(user)
    end
  end
end
