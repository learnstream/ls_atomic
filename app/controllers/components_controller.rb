class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy, :update ]
  
  def create
    course_id = params[:component][:course_id]
    if course_id.nil?
      @component = Component.new(params[:component])
    else
      course = Course.find(course_id)
      @component = course.components.build(params[:component])
    end

    if @component.save
      flash[:success] = "Knowledge component created!"
      if course_id.nil?
        redirect_to :db 
      else
        redirect_to course_path(course_id)
      end
    else
      @components = Component.all
      render 'components/list' 
    end
  end

  def destroy
  end

  def edit
    @component = Component.find(params[:id])
  end


  def update
    course_id = params[:component][:course_id]
    @component = Component.find(params[:id])
    @component.name = params[:component][:name]
    @component.description = params[:component][:description]
    if @component.save
      flash[:success] = "Knowledge component created!"
      if course_id.nil?
        redirect_to :db 
      else
        redirect_to course_path(course_id)
      end
    else
      # Or redirect to an edit_k-component_path?
      # Do we want microform?
      redirect_to course_path(course_id)
    end
  end

  def show
    @component = Component.find(params[:id])
    @title = @component.name
  end

  def list
    @components = Component.all
    @component = Component.new if signed_in?
  end
end
