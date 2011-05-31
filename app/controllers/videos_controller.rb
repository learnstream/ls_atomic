class VideosController < ApplicationController
  before_filter :authenticate
  #add authentication for teachers/admins...

  def create
    component_id = params[:video][:component_id]
    component = Component.find(component_id)

    @video = component.videos.build(params[:video])

                                    #:url => params[:video][:url], 
                                    #:start_time => params[:video][:start_time],
                                    #:end_time => params[:video][:end_time])
    @video.save!
 
    if @video.save
      flash[:success] = "Video created!"
      redirect_to component_path(component_id)
    else
      flash[:error] = "Sorry, there was an error. Try again. If error persists, contact customer support."
      redirect_to component_path(component_id)
    end
  end

  def destroy
  end

  def update
  end

end
