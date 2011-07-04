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

    @lessons = @course.lessons.all()
    @lesson_statuses = current_user.lesson_statuses.includes(:lesson).joins(:lesson).merge(Lesson.where(:course_id => @course))
    @components = @course.components
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      current_user.enroll_as_teacher!(@course)
      if(params[:course][:document].nil?)
        flash[:success] = "New course created!"
        redirect_to @course 
        return
      end
    else
      @title = "New Course"
      render 'new'
      return
    end

    result = @course.populate_with_tex(params[:course][:document])
    if result[:success]
      flash[:success] = "Course created and problems/components added!"
      redirect_to @course
    else
      document = params[:course][:document]
      result[:problems_added].each { |problem|
        document.gsub!("\\begin{problem}" + problem.first + "\\end{problem}", "")
      }
      @course.document = document
      @latex_on = true;
      render 'edit', :document => params[:course][:document]
    end

  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @latex_on = false

    if(@course.update_attributes(params[:course]))
      flash[:success] = "Course info saved!"
      if(params[:course][:document].nil?)
        redirect_to course_problems_path(@course)
      end
    else
      @course.document = params[:course][:document]
      @latex_on = true
      render 'edit'
      return
    end

    result = @course.populate_with_tex(params[:course][:document])
    if result[:success]
      flash[:success] = "Problems and Components added!"
      redirect_to course_problems_path(@course)
    else
      document = params[:course][:document]
      result[:problems_added].each { |problem|
        document.gsub!("\\begin{problem}" + problem.first + "\\end{problem}", "")
      }
      @course.document = document
      @latex_on = true;
      render 'edit', :document => params[:course][:document]
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
    ratings = current_user.memory_ratings.ratings_after(DateTime.now.utc - 28.days).in_course(@course)

    (0..28).each do |i| 
      correct_output << [i, 0]
      total_output << [i, 0]
    end

    ratings.each do |rating|
      day = 28 - ((Time.now.utc - rating.created_at)/60/60/24).round
      if rating.quality != 0
        correct_output[day] = [day, correct_output[day][1] + 1]
      end
      total_output[day] = [day, total_output[day][1] + 1]
    end
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

    current_user.memories.in_course(@course).includes(:memory_ratings).each{ | memory|
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
    @lessons = @course.lessons.includes(:lesson_statuses)
    @students_selected = "selected"
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
      if [ 'student_status', 'edit' ].include? action_name
        'teacher'
      else
        'application'
      end
    end
end
