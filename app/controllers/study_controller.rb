class StudyController < ApplicationController

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.in_course(@course).due_before(Time.now).first

    if @memory
      @component = @memory.component

      unless @component.steps.empty? 
        @step = @component.steps.first
      end
    else 
      @component = nil
      @step = nil
    end

    render 'index'
  end
end
