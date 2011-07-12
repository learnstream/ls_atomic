module ResponsesHelper
  def user_answer(response)
    if response.quiz.answer_type == 'multi'
      show_multi_answer(response.answer, response.quiz.answer_input)
    elsif response.quiz.answer_type == 'check'
      show_check_answer(response.answer, response.quiz.answer_input)
    else
      response.answer
    end
  end

  def quiz_answer(response)
    if response.quiz.answer_type == 'multi'
      show_multi_answer(response.quiz.answers.first.text, response.quiz.answer_input)
    elsif response.quiz.answer_type == 'check'
      show_check_answer(response.quiz.answers.first.text, response.quiz.answer_input)
    else
      response.quiz.answers.first.text
    end
  end

  def show_multi_answer(answer, answer_input)
    ActiveSupport::JSON.decode(answer_input)["choices"][answer.to_i]
  end
  
  def show_check_answer(answer, answer_input)
    answers = answer.split("")
    str = ""
    answers.each do |ans|
      str += ActiveSupport::JSON.decode(answer_input)["choices"][ans.to_i] + "\n"
    end
    str
  end
end
