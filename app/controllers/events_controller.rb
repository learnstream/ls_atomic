class EventsController < ApplicationController

  def index
    @lesson = Lesson.find(params[:lesson_id])
    @events = @lesson.events.all

    events_json = []

    @events.each do |event|
      event_json = {}
      event_json["type"] = event.playable_type
      event_json["id"] = event.playable_id
      event_json["event_id"] = event.id
      
      if event.playable_type == "Note"
        event_json["pause"] = false
        event_json["content"] = event.playable.content
      else
        event_json["pause"] = true
      end

      event_json["video_url"] = event.video_url
      event_json["start_time"] = event.start_time
      event_json["end_time"] = event.end_time
      
      events_json << event_json
    end

    current_event = @lesson.lesson_statuses.find_by_user_id(current_user).event_id

    respond_to do |format|
      format.json { render :json => {:events => events_json, :current_event => current_event}}
      format.html   { render :partial => "event", :collection => @events, :as => :event, :layout => false }
    end
  end
end
