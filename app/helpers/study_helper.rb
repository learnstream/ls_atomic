module StudyHelper

  # Our answer field contains the number of the response, not the actual answer
  def showMultiAnswer(answer, answer_input)
    ActiveSupport::JSON.decode(answer_input)["choices"][answer.to_i]
  end
  
end
