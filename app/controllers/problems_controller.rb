class ProblemsController < ApplicationController
  before_filter :authenticate,

  def create
    course_id = params[:problem][:course_id]
    if course_id.nil?
      flash[:error] = "If you know what's good, add a course. I have no idea what you did"
      redirect_to root_path
    else
      course = Course.find(course_id)
      @problem = course.problems.build(params[:problem])
    end

    if @problem.save
      flash[:success] = "Problem created!"
      redirect_to problem_path
    else
      flash[:error] = "There was a problem saving. Try again, or not."
      redirect_to course_path(course_id)
    end   
  end

  #def new
  #end

  def edit

  end

  def update

  end

  def show

  end

end
