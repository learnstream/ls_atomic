class QuizzesController < ApplicationController
  layout :choose_layout 

  before_filter :authenticate
  before_filter :only => [:create, :update, :new, :edit] do
    check_permissions(params)
  end

  def new 
    @problem = Problem.find(params[:problem_id])
    @quiz = Quiz.new
  end

  def create 
   problem = Problem.find(params[:quiz][:problem_id])
   course = problem.course

   if problem.nil?
     flash[:error] = "You're trying to add a quiz to a problem that doesn't exist"
     redirect_to root_path
     return
   end 

   @quiz = problem.quizzes.build(params[:quiz])
   @quiz.answer_input = params[:quiz][:answer_type]
   @quiz.answer_output = params[:quiz][:answer_type]


   if @quiz.save
     flash[:success] = "Quiz created!"
     redirect_to course
   else
     @problem = problem
     render 'new'
   end
  end

  def show
    @quiz = Quiz.find(params[:id])
    @user = current_user
    @course = @quiz.problem.course
    @response = Response.new

    if @quiz.answer_type == "text"
      @input_fields = "text_input"
    else
      @input_fields = nil
    end
  end

  def update
    @quiz = Quiz.find(params[:id])
    
    if @quiz.update_attributes(params[:quiz])
      flash[:success] = "Quiz edited."
      redirect_to course_path(@quiz.course)
    else
      render :action => 'edit'
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @problem = @quiz.problem
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

    redirect_to course_study_index_path(@quiz.problem.course)
  end

  private 
  
    def check_permissions(params)

      course = Quiz.find(params[:id]).course unless params[:id].nil?
      course ||= Problem.find(params[:problem_id]).course unless params[:problem_id].nil?
      course ||= Problem.find(params[:quiz][:problem_id]).course unless params[:quiz].nil? or params[:quiz][:problem_id].nil?

      if course.nil? 
        flash[:error] = "Try going to the course page to create a quiz"
        redirect_to root_path
        return false
      end

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permission to edit this course"
        redirect_to root_path
        return false
      end
    end

    def choose_layout
      if [ 'show' ].include? action_name
        'study'
      else
        'application'
      end
    end
end
