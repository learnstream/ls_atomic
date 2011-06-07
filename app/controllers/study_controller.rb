class StudyController < ApplicationController
  before_filter :authenticate

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.in_course(@course).due_before(Time.now.utc).first

    if @memory.nil?
      render 'index'
      return
    end

    @quiz = @memory.component.quizzes.first
    while not @quiz and @memory 
      @memory.view(0)
      @memory = current_user.memories.in_course(@course).due_before(Time.now.utc).first 
      @quiz = @memory.component.quizzes.first
    end

    redirect_to @quiz
  end
end
