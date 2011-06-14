class CoursesController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => [:new, :create]
  before_filter :authorized_teacher, :only => [:student_stats]

  layout :choose_layout

  def new
    @course = Course.new
    @title = "New Course"
  end

  def show
    @course = Course.find(params[:id])
    
    if current_user.can_edit?(@course)
      redirect_to student_status_course_path(@course)
      return 
    end

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
    total_output = []
    correct_output = []
    (0..28).each { |i|
      success_ratio = nil
      start_time = Time.now.utc - (29 - i).day
      end_time = Time.now.utc - (28 - i).day
      day_stats = current_user.stats(@course, start_time, end_time)
      total_mr = day_stats.sum
      correct_mr = total_mr - day_stats[0] 
      total_output << [ i, total_mr ] 
      correct_output << [i, correct_mr]
      }
    output_json = { :success_stats => [ {label: "Total", lines: {fill: true, fillColor: "rgba(0,0,255,0.8)"}, data: total_output},{label: "Correct", lines: {fill: true, fillColor: "rgba(0,255,0,0.8)"}, data: correct_output}] }
    respond_to do |format|
      format.json { render :json => output_json.to_json }
    end
  end

  def cards_due_stats
    @course = Course.find(params[:id])     
    output = []
    (0..21).each{ |i|
      cards_due_day = current_user.memories.in_course(@course).due_before(Time.now.utc + i.day)
      output << [i, cards_due_day.count]
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
    diff = (Date.today - first_rating.created_at.to_date).to_i
    (0..diff).each{ |i|
      output << [i, 0]
    }

    current_user.memories.in_course(@course).each{ | memory|
      ignore_below = 0 
      memory.memory_ratings.each { |rating|
        interval = rating.interval.floor
        index  = (rating.created_at.to_date - first_rating.created_at.to_date).to_i
        (0..interval).each { |i| 
          if (i >= ignore_below and ((index + i) < output.length))
            output[index + i][1] += 1
          end
        }
        # Skip over days that have already been counted
        ignore_below = index + interval
      }
    }
    
    total_memories = @course.components.count

    output.each do |x|
      if total_memories == 0
        x[1] = 1.0
      else   
        x[1] = Float(x[1]) / total_memories
      end
    end

    output_json = { :course_achieved_stats => [output] }
    respond_to do |format|
      format.json { render :json => output_json.to_json }
    end
  end

  def student_status
    @course = Course.find(params[:id])
  end

  private

    def authorized_user
      if current_user.nil? or (current_user.perm != "admin" and current_user.perm != "creator")
        redirect_to root_path
      end
    end

    def authorized_teacher
      @course = Course.find(params[:id])
      if current_user.nil? or (current_user.perm != "admin" and !current_user.teacher?(@course))
        redirect_to root_path
      end
    end
    
    def choose_layout
      if [ 'student_status' ].include? action_name
        'teacher'
      else
        'application'
      end
    end
end
