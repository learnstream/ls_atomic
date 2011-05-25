class CoursesController < ApplicationController
  def new
    @course = Course.new
    @title = "New Course"
  end

  def show
    @course = Course.find(params[:id])   
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

end
