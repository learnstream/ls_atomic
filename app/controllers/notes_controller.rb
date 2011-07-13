class NotesController < ApplicationController
  before_filter :authenticate
  def create
    @note = Note.new(params[:note])

    if @note.save
      @event = @note.events[0]
      @note = Note.new
      respond_to do |format|
        format.js   
      end
    end
  end

  def new
    @note = Note.new
    @note.events.build
  end

  def edit
    @note = Note.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    params[:note][:existing_event_attributes] ||= {}

    @updated_note = Note.find(params[:id])
    @event = @updated_note.events[0]
    @updated_note.update_attributes(params[:note])
    @note = Note.new
                                   
    respond_to do |format|
      format.js   
    end
  end
end
