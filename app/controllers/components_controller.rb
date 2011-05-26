class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy ]
  
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

  def show
    @component = Component.find(params[:id])
    @title = @component.name
  end

  def list
    @components = Component.all
    @component = Component.new if signed_in?
  end
end
