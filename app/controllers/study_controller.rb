class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.course_exercise(@course).first

    if @memory.nil?
      render 'index'
      return
    end

    #Choose a random quiz
    @quiz = @memory.component.quizzes.exercises.sample
    if @quiz
      redirect_to @quiz
    else
      render 'index'
      return
    end
  end
end


