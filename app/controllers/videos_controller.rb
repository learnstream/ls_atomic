class VideosController < ApplicationController
  before_filter :authenticate
  before_filter do
    check_permissions(params)
  end

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

  private

    def check_permissions(params)

      course = Video.find(params[:id]).component.course unless params[:id].nil? 
      course ||= Component.find(params[:video][:component_id]).course

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end


end
