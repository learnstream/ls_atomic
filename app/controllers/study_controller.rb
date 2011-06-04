class StudyController < ApplicationController
  before_filter :authenticate

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.in_course(@course).due_before(Time.now.utc).first

    if @memory
      @component = @memory.component

      unless @component.quizzes.empty?
        @quiz = @component.quizzes.first
        redirect_to quiz_path(@quiz)
        return
      end
    else 
      @component = nil
      @step = nil
    end

    render 'index'
  end
end
