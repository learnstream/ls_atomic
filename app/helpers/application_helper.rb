module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("quizzes/" + association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :id => "addanswerbutton")
  end

  # For showing multiple choice quizzes and answers
  #
  def quiz_answer(quiz)
    if quiz.answer_type == 'multi'
      show_multi_answer(quiz.answers.first.text, quiz.answer_input)
    elsif quiz.answer_type == 'check'
      show_check_answer(quiz.answers.first.text, quiz.answer_input)
    else
      quiz.answers.first.text
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

  def show_multi_choices(answer_input)
    str = '<ul>'
    ActiveSupport::JSON.decode(answer_input)["choices"].each do |choice| 
      str += '<li>' + choice + '</li>'
    end
    str += '</ul>'
    str
  end

end
