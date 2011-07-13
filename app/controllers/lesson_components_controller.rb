class LessonComponentsController < ApplicationController

  before_filter :authenticate 
  def create
    @lc = LessonComponent.new(params[:lesson_component])
    @lc.save

    respond_to do |format|
      format.js
    end
  end



  def update
    @lc = LessonComponent.find(params[:id])
    @lesson = @lc.lesson
    @course = @lesson.course

    if @lc.update_attributes(params[:lesson_component])
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_course_lesson_path(@course,@lesson)
    end
  end

  def destroy
    @lc = LessonComponent.find(params[:id])
    @lc.destroy

    respond_to do |format|
      format.js
    end
  end
end
