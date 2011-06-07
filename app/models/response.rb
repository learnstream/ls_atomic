class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz

  before_save :grade_response

  def grade_response
    if self.quiz.answer_type != "self-rate" 
      if self.quiz.check_answer(self) 
        self.status = "correct"
      else
        self.status = "incorrect"
        self.quiz.rate_components!(self.user, 0)
      end
    else
      self.status = ""
    end
  end
end
