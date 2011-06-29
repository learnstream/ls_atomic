class QuizzesController < ApplicationController
  layout 'teacher'

  before_filter :grab_course_from_course_id 
  before_filter :authenticate
  before_filter :authorized_teacher, :only => [:create, :update, :new, :edit, :index] 
  before_filter :select_quizzes

  def index
    @quizzes = @course.quizzes
  end

  def new 
    @quiz = Quiz.new
    @lesson = nil
  end

  def create 
    populate_answer_json(params[:quiz][:answer_type])


    @lesson = Lesson.find(params[:quiz][:new_event_attributes][:lesson_id]) if params[:quiz].has_key?("new_event_attributes")
    if @lesson
      params[:quiz][:in_lesson] = true
    end

    @quiz = @course.quizzes.build(params[:quiz])
    if @quiz.save
      respond_to do |format|
        format.html {
          flash[:success] = "Quiz created!"
          redirect_to course_quizzes_path(@course)
        }
        format.js {
          @event = @quiz.events[0]
          @quiz = @course.quizzes.new
          answer = @quiz.answers.build
        }
      end
    else
      render 'new'
    end
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def update
    params[:quiz][:existing_event_attributes] ||= {}
    @quiz = Quiz.find(params[:id])
    @lesson = Lesson.find(params[:quiz][:existing_event_attributes][:lesson_id]) if params[:quiz][:existing_event_attributes].has_key?("lesson_id")

    populate_answer_json(params[:quiz][:answer_type])

    if @quiz.in_lesson 
      @quiz.events.first.update_attributes(:start_time => params[:start_time], :end_time => params[:end_time], :video_url => params[:video_url])
    end

    if @quiz.update_attributes(params[:quiz])
      respond_to do |format|
        format.html   {
          flash[:success] = "Quiz edited."
          redirect_to course_quizzes_path(@quiz.course)
        }
        format.js {
          @updated_quiz = @quiz
          @event = @updated_quiz.events[0]
          @quiz = @course.quizzes.new
          render 'update'
        }
      end
    else
      respond_to do |format| 
        format.html { render :action => 'edit' }
      end
    end

  end

  def edit
    @quiz = Quiz.find(params[:id])
    @lesson = nil
    respond_to do |format|
      format.html
      format.js {
        @event = @quiz.events[0]
        @lesson = @event.lesson
      }
    end
  end

  private 
  
  def grab_course_from_course_id
    @course = Course.find(params[:course_id]) if params[:course_id]
  end

  def authorized_teacher
    if current_user.perm != "admin" and !current_user.teacher?(@course)
      redirect_to root_path
    end
  end

  def jsonify(type, options=nil)
    options ? { :type => type, :options => options }.to_json : { :type => type }.to_json
  end

  def populate_answer_json(answer_type)
    if params[:quiz][:answer_input].blank?
      params[:quiz][:answer_input] = { :type => answer_type }.to_json 
    end

    if params[:quiz][:answer_output].blank?
      params[:quiz][:answer_output] = { :type => "text" }.to_json
    end
  end 

  def select_quizzes
    @exercises_selected = "selected"
  end
end
