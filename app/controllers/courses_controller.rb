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
    @problems = @course.problems
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

  def stats
    @course = Course.find(params[:id])
    output = []
    (1..30).each { |i|
      success_ratio = nil
      start_time = Time.now.utc - (31 - i).day
      end_time = Time.now.utc - (30 - i).day
      day_stats = current_user.stats(@course, start_time, end_time)
      success_ratio = (day_stats.sum - day_stats[0]) / day_stats.sum unless day_stats.sum == 0
      output << [ i, success_ratio ] unless success_ratio.nil?
      }
    output_json = { :stats => [output] }
    respond_to do |format|
      format.json { render :json => output_json.to_json }
    end
  end
  private

    def authorized_user
      if @current_user.perm == "learner"
        redirect_to(@current_user)
      end
    end
end
