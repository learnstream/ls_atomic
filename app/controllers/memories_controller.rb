class MemoriesController < ApplicationController

  def rate
    @memory = Memory.find(params[:id])

    success = @memory.view(Integer(params[:quality]))
    @memory.save if success

    redirect_to course_study_index_path(@memory.component.course)
  end
end
