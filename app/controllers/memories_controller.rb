class MemoriesController < ApplicationController

  before_filter :authenticate
  before_filter :student, :only  => :index

  def rate
    @memory = Memory.find(params[:id])

    success = @memory.view(Integer(params[:quality]))
    @memory.save if success

    redirect_to course_study_index_path(@memory.component.course)
  end

  def update
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.find(params[:id])
    if @memory.remove!
    else 
      flash[:error] = "The memory could not be removed."
    end

    redirect_to course_memories_path(@course)
  end

  def index 
    @course = Course.find(params[:course_id])
    @memories = current_user.memories.in_course(@course)
  end

  private
    
    def student
      @course = Course.find(params[:course_id])
      if current_user.memories.in_course(@course).empty?
        redirect_to course_path(@course)
      end
    end

end
