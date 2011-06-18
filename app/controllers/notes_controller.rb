class NotesController < ApplicationController
  def create
    @note = Note.new(params[:note])

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
    @note.events.build
  end

  def update
    params[:note][:existing_event_attributes] ||= {}

    @note = Note.find(params[:id])
    @note.update_attributes(params[:note])
                                   
    respond_to do |format|
      format.html   { render :text =>  "testupdate" } 
    end
  end
end
