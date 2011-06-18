class QuizzesController < ApplicationController
  layout :choose_layout 

  before_filter :grab_course_from_course_id 
  before_filter :authenticate
  before_filter :authorized_teacher, :only => [:create, :update, :new, :edit, :index] 

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
      last_event = @lesson.events.last
      next_event = last_event.nil? ?  0 : last_event.order_number + 1
      params[:quiz][:in_lesson] = true
      params[:quiz][:new_event_attributes][:order_number] = next_event
    end

    @quiz = @course.quizzes.build(params[:quiz])

    if @quiz.save
      flash[:success] = "Quiz created!"
      redirect_to course_quizzes_path(@course)
    else
      render 'new'
    end
  end

  def show
    @quiz = Quiz.find(params[:id])
    @user = current_user
    @course = @quiz.course
    @response = Response.new

    if @quiz.answer_type == "text"
      @input_fields = "text_input"
    elsif @quiz.answer_type == "fbd"
      @input_fields = "fbd_student_input"
    else
      @input_fields = nil
    end
  end

  def update
    params[:quiz][:existing_event_attributes] ||= {}
    @quiz = Quiz.find(params[:id])

    populate_answer_json(params[:quiz][:answer_type])

    if @quiz.update_attributes(params[:quiz])
      flash[:success] = "Quiz edited."
      redirect_to course_quizzes_path(@quiz.course)
    else
      render :action => 'edit'
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @lesson = nil
    if @quiz.in_lesson
      @event = @quiz.events[0]
      @lesson = @event.lesson
    end
    respond_to do |format|
      format.html { render 'edit' }
      format.js { render :partial => 'form' }
    end
  end

  def rate_components
    @quiz = Quiz.find(params[:id])
    @firstcomponent = @quiz.components.first 
    @memory = current_user.memories.find_by_component_id(@firstcomponent)

    if((@memory.due - Time.now) > 0)
      flash[:error] = "You have already rated your response for that problem!"
    else
      @quiz.rate_components!(current_user, Integer(params[:quality]))
    end

    redirect_to course_study_index_path(@quiz.course)
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

  def choose_layout
    if [ 'show' ].include? action_name
      'study'
    elsif [ 'new', 'edit', 'index' ].include? action_name
      'teacher'
    else
      'application'
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
end
