class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy, :update, :edit ]
  before_filter :only => [:create, :edit, :update, :new] do 
    check_permissions(params)
  end 

  def new 
    @course = Course.find(params[:course_id])
    @component = Component.new
  end
 
  def create
    course_id = params[:component][:course_id]
    course = Course.find(course_id)

    @component = course.components.build(params[:component])
    
    if @component.save
      flash[:success] = "Knowledge component created!"
      redirect_to course_path(course_id)
    else
      @course = course
      render 'new'
    end
  end

  def destroy
  end

  def edit
    @component = Component.find(params[:id])
    @video = Video.new
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
      render 'edit'
    end
  end

  def show
    @component = Component.find(params[:id])
    @video = @component.videos[0]
    @title = @component.name
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
      course ||= Course.find(params[:course_id]) unless params[:course_id].nil?
      course ||= Course.find(params[:component][:course_id])

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end
end
