class LessonsController < ApplicationController
  layout :choose_layout

  before_filter :grab_course_from_course_id 
  before_filter :authenticate
  before_filter :authorized_teacher, :except => :show 

  def index
    @lessons = @course.lessons
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = @course.lessons.build(params[:lesson])

    if @lesson.save
      flash[:success] = "Lesson created!"
      redirect_to edit_course_lesson_path(@course, @lesson)
    else
      render 'new'
    end
  end

  def edit
    @lesson = @course.lessons.find(params[:id])
    @events = @lesson.events
    @note = Note.new
    @quiz = Quiz.new
  end

  def update
    @lesson = Lesson.find(params[:id])

    if @lesson.update_attributes(params[:lesson])
      flash[:success] = "Lesson updated!"
      redirect_to course_lessons_path(@course)
    else
      @events = @lesson.events
      render 'edit'
    end
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
  end
  
  private

  def grab_course_from_course_id
    @course = Course.find(params[:course_id]) if params[:course_id]
  end

  def choose_layout 
    if [ 'show' ].include? action_name
      'application'
    else
      'teacher'
    end
  end
  
  def authorized_teacher
    if current_user.perm != "admin" and !current_user.teacher?(@course)
      redirect_to root_path
    end
  end
end
