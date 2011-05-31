class StudyController < ApplicationController
  before_filter :authenticate

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.in_course(@course).due_before(Time.now).first

    if @memory
      @component = @memory.component

      unless @component.steps.empty? 
        @step = @component.steps.first
        @problem = @step.problem
        @steps = @problem.steps.steps_up_to(@step.order_number)
        @index = @problem.steps.index(@step) + 1
      end
    else 
      @component = nil
      @step = nil
    end

    render 'index'
  end
end
