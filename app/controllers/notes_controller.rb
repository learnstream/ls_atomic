class NotesController < ApplicationController
  def create
    @lesson = Lesson.find(params[:lesson_id])
    last_event = @lesson.events[-1]
    next_event = last_event.nil? ?  0 : last_event.order_number + 1
    @new_note = Note.new(params[:note])

    @new_note.events.build(:start_time => params[:start_time], :end_time => params[:end_time], 
                       :video_url => params[:video_url], :lesson_id => params[:lesson_id], 
                       :order_number => next_event)

    if @new_note.save
      flash[:success] = "New note created!"
    else
      render 'new'
    end
  end

  def new
    @note = Note.new
  end

end
