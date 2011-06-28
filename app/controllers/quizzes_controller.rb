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
    @user = current_user
    @course = @quiz.course

    # Look through all the components to make sure that at least one is due,
    # and that it has already been self-rated.
    notdue = true
    notrated = false
    most_recent = @quiz.responses.by_user(@user).last
    @quiz.components.each { |component|
      due = @user.memories.find_by_component_id(component).due
      if((due - Time.now) <= 0)
        notdue = false
        if(most_recent && (most_recent.status == "correct") && (due < most_recent.created_at))
          notdue = true
          notrated = true
        end
      end
    }

    # If the above conditions are not met, flash an error and do not create a
    # new response
    if(notdue)
      if(most_recent)
        respond_to do |format|
          format.html { redirect_to most_recent }
          format.js { 
            @response = most_recent
            render 'responses/show', :format => :js
          }
        end
      else
        redirect_to @course
      end

      return
    end

    @response = Response.new

    respond_to do |format|
      format.html
      format.js { render 'show', :format => :js }
    end
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
