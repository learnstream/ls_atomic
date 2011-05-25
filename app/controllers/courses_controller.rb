class CoursesController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:new, :create]
  
  def new
    @course = Course.new
    @title = "New Course"
  end

  def show
    @course = Course.find(params[:id])   
    @components = @course.components
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      flash[:success] = "New course created!"
      redirect_to @course 
    else
      @title = "New Course"
      render 'new'
    end
  end

  private

    def authorized_user
      if @current_user.perm == "learner"
        redirect_to(@current_user)
      end
    end
end
