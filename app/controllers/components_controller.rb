class ComponentsController < ApplicationController
  layout :choose_layout

  before_filter :authenticate
  before_filter :except => [:show] do 
    check_permissions(params)
  end 
  before_filter :select_components

  def new 
    @course = Course.find(params[:course_id])
    @component = Component.new
  end
 
  def create
    @course = Course.find(params[:course_id])

    @component = @course.components.build(params[:component])
    
    if @component.save
      flash[:success] = "Knowledge component created!"
      redirect_to course_components_path(@course)
    else
      render 'new'
    end
  end

  def destroy
  end

  def edit
    #@course = Course.find(params[:course_id])
    @component = Component.find(params[:id])
    @course = @component.course
    @video = Video.new
    @videos = @component.videos
  end

  def update
    @component = Component.find(params[:id])
    @course = @component.course #should be able to get this from params..
    @component.name = params[:component][:name]
    @component.description = params[:component][:description]
  
    if @component.save
      flash[:success] = "Knowledge component updated!"
      redirect_to course_component_path(@course, @component)
    else
      render 'edit'
    end
  end

  def show
    @course = Course.find(params[:course_id])
    @component = Component.find(params[:id])
    @videos = @component.videos
    @title = @component.name
  end

  def index
    @course = Course.find(params[:course_id])
    respond_to do |format|
      format.html do
        @components = @course.components.paginate(:page => params[:page], :per_page => 15)
      end

      format.json { 
        @components = @course.components.where("name like ?", "%#{params[:q]}%")
        render :json => @components.map(&:attributes) }
    end
  end

  private

    def check_permissions(params)
      course = Component.find(params[:id]).course unless params[:id].nil? 
      course ||= Course.find(params[:course_id]) unless params[:course_id].nil?
      course ||= Course.find(params[:component][:course_id])

      unless current_user.can_edit?(course)
        flash[:error] = "You need to be a teacher or an admin to do that!"
        redirect_to root_path
        return false
      end 
    end

    def choose_layout
      if [ 'index', 'edit', 'new' ].include? action_name
        'teacher'
      else
        'application'
      end
    end

    def select_components
      @components_selected = "selected"
    end
end
