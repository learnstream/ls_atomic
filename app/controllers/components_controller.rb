class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy, :update, :edit ]
  
  def create
    course_id = params[:component][:course_id]
    
    if course_id.nil?
      return # Need to validate the components still!!
      #@component = Component.new(params[:component])
    else
      course = Course.find(course_id)

      if(current_user.can_edit?(course))
        @component = course.components.build(params[:component])
      else
        flash[:error] = "You don't have permission to create components!"
        redirect_to root_path
        return
      end
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
      flash[:success] = "Knowledge component updated!"
      redirect_to component_path
    else
      flash[:error] = "You fucked up!" #change...?
      redirect_to component_path
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
