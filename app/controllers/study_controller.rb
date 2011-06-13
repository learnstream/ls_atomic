class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories_due_with_quiz(@course).first

    if @memory.nil?
      render 'index'
      return
    end

    #Choose a random quiz
    @quiz = @memory.component.quizzes.sample
    redirect_to @quiz
  end
end


