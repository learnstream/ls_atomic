class MemoriesController < ApplicationController

  before_filter :authenticate
  before_filter :student, :only  => :index

  def update
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.find(params[:id])
    if @memory.update_attributes(params[:memory])
    else 
      flash[:error] = "The memory could not be updated."
    end

    redirect_to course_memories_path(@course)
  end

  def index 
    @course = Course.find(params[:course_id])
    @memories = current_user.memories.in_course(@course).where("views > 0")
    @locked_memories = current_user.memories.in_course(@course).where("views = 0")
  end

  private
    
    def student
      @course = Course.find(params[:course_id])
      if current_user.memories.in_course(@course).empty?
        redirect_to course_path(@course)
      end
    end

end
