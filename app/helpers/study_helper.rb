module StudyHelper

  # Our answer field contains the number of the response, not the actual answer
  def showMultiAnswer(answer, answer_input)
    ActiveSupport::JSON.decode(answer_input)["choices"][answer.to_i]
  end
  
  def showCheckAnswer(answer, answer_input)
    answers = answer.split("")
    str = ""
    answers.each do |ans|
      str += ActiveSupport::JSON.decode(answer_input)["choices"][ans.to_i] + "\n"
    end
    str
  end

end
