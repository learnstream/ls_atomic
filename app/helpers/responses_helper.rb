module ResponsesHelper
  def user_answer(response)
    if response.answer = ""
      ""
    elsif response.quiz.answer_type == 'multi'
      show_multi_answer(response.answer, response.quiz.answer_input)
    elsif response.quiz.answer_type == 'check'
      show_check_answer(response.answer, response.quiz.answer_input)
    else
      response.answer
    end
  end
end
