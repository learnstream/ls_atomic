class NotesController < ApplicationController
  def create
    @lesson = Lesson.find(params[:lesson_id])
    last_event = @lesson.events[-1]
    next_event = last_event.nil? ?  0 : last_event.order_number + 1
    @note = Note.new(params[:note])

    @note.events.build(:start_time => params[:start_time], :end_time => params[:end_time], 
                       :video_url => params[:video_url], :lesson_id => params[:lesson_id], 
                       :order_number => next_event)

    if @note.save
      message = "Note saved!"
    else
      message = "Error."
    end


    respond_to do |format|
      format.html   { render :text =>  message } 
    end


  end

  def new
    @note = Note.new
  end

  def update
    @note = Note.find(params[:id])
    @note.update_attributes(params[:note])
    @note.events.first.update_attributes( :start_time => params[:start_time],  :end_time => params[:end_time], 
                                    :video_url => params[:video_url]) 
                                   

    respond_to do |format|
      format.html   { render :text =>  "testupdate" } 
    end


  end
end
