class VideosController < ApplicationController
  before_filter :authenticate
  before_filter do
    check_permissions(params)
  end

  def create

    component_id = params[:video][:component_id]
    if(component_id)
      component = Component.find(component_id)
      @video = component.videos.build(params[:video])
      @redirect = edit_component_path(component_id)
    end

    step_id = params[:video][:step_id]
    if(step_id)
      step = Step.find(step_id)
      @video = step.videos.build(params[:video])
      @redirect = edit_step_path(step_id)
    end
 
    if @video.save!
      flash[:success] = "Video created!"
      redirect_to @redirect 
    else
      render @redirect 
    end
  end

  def destroy
    video = Video.find(params[:id])
    
    if(video.component_id)
      redirect = edit_component_path(video.component_id)
    elsif(video.step_id)
      redirect = edit_step_path(video.step_id)
    end
    video.delete
    flash[:success] = "Video deleted!"
    redirect_to redirect
  end

  def update
    @video = Video.find(params[:id])
    @component = @video.component
    @video.attributes = params[:video]

    if @video.save
      flash[:success] = "Video updated!"
      redirect_to edit_component_path(@component)
    else
      render 'edit'
    end 
  end

  def edit
    @video = Video.find(params[:id])
    @component = @video.component
  end

  private

    def check_permissions(params)

      if params[:id]
        video = Video.find(params[:id])
        if video.step
          course = video.step.problem.course
        else
          course = video.component.course
        end
      else
        if params[:video][:step_id]
          course = Step.find(params[:video][:step_id]).problem.course
        else
          course = Component.find(params[:video][:component_id]).course 
        end
      end
      
      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end


end
