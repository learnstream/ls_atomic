class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])

    @quiz = nil
    while @quiz.nil?
      @memory = current_user.memories_due(@course).first 
      if @memory.nil? 
        render 'index'
        return
      end
      
      @quiz = @memory.component.quizzes.first
      
      if @quiz.nil?
        @memory.view(0)
      end
    end
    redirect_to @quiz
  end
end


