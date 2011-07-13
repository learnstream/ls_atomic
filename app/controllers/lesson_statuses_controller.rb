class LessonStatusesController < ApplicationController

  before_filter :authenticate

  def update
    @lesson_status = LessonStatus.find(params[:id])

    @lesson_status.update_attributes(params[:lesson_status])

    if @lesson_status.save!
      head 200
    else
      head 500
    end
  end
end
