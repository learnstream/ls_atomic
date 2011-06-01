class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy, :update, :edit ]
  before_filter :only => [:create, :edit, :update] do 
    check_permissions(params)
  end 
 
  def create

    course_id = params[:component][:course_id]
    course = Course.find(course_id)

    @component = course.components.build(params[:component])
    
    if @component.save
      flash[:success] = "Knowledge component created!"
      redirect_to course_path(course_id)
    else
      flash[:error] = "Something went wrong... contact customer support!"
      @components = Component.all
      render 'components/list' 
    end
  end

  def destroy
  end

  def edit
    @component = Component.find(params[:id])
    @video = Video.new
    @videos = @component.videos
  end


  def update
    course_id = params[:component][:course_id]
    @component = Component.find(params[:id])
    @component.name = params[:component][:name]
    @component.description = params[:component][:description]
  
    if @component.save
      flash[:success] = "Knowledge component updated!"
      redirect_to component_path
    else
      flash[:error] = "You fucked up!" 
      redirect_to component_path
    end
  end

  def show
    @component = Component.find(params[:id])
    @videos = @component.videos
    @title = @component.name
  end

  def list
    @components = Component.all
    @component = Component.new if signed_in?
  end

  def describe
    @component = Component.find(params[:id])
    respond_to do |format|
      format.json { render :json => {
        :text => @component.description
        }
      }
    end
  end


  private

    def check_permissions(params)

      course = Component.find(params[:id]).course unless params[:id].nil? 
      course ||= Course.find(params[:component][:course_id])

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end

end
