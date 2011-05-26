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
    @component = Component.new
    @problems = @course.problems
    @problem = Problem.new
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      flash[:success] = "New course created!"
      current_user.enroll_as_teacher!(@course)
      redirect_to @course 
    else
      @title = "New Course"
      render 'new'
    end
  end

  def index
    @courses = Course.all
  end

  def users
    @title = "Users"
    @course = Course.find(params[:id])
    @teachers = @course.teachers
    @students = @course.students.paginate(:page => params[:page])
    render 'show_users'
  end


  private

    def authorized_user
      if @current_user.perm == "learner"
        redirect_to(@current_user)
      end
    end
end
