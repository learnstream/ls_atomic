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

  def success_stats 
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
    output_json = { :success_stats => [output] }
    respond_to do |format|
      format.json { render :json => output_json.to_json }
    end
  end

  def cards_due_stats
    @course = Course.find(params[:id])     
    output = []
    (0..21).each{ |i|
      cards_due_day = current_user.memories.in_course(@course).due_before(Time.now.utc + i.day)
      output << [i, cards_due_day]
    }
    output_json = { :cards_due_stats => [output] }
    respond_to do |format|
      format.json { render :json => output_json.to_json }
    end
  end

  def course_achieved_stats
    @course = Course.find(params[:id])
    output = []
    first_rating = current_user.memory_ratings.in_course(@course).first
    diff = (DateTime.now.day - first_rating.created_at.day)
    (0..diff).each{ |i|
      output << [i, 0]
    }

    current_user.memories.in_course(@course).each{ | memory|
      ignore_below = 0 
      memory.memory_ratings.each { |rating|
        interval = rating.interval.floor
        index  = rating.created_at - first_rating.created_at
        (0..interval).each { |i| 
          if (i >= ignore_below and ((index + i) < output.length))
            output[index + i][1] += 1
          end
        }
        # Skip over days that have already been counted
        ignore_below = index + interval
      }
    }
    
    output_json = { :course_achieved_stats => [output] }
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
