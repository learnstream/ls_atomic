class ResponsesController < ApplicationController
  layout "study", :only => [:show]
  
  def create

    # Don't allow user to create a new response if they have
    # already responded
    @quiz = Quiz.find(params[:response][:quiz_id])
    @course = @quiz.problem.course
    @component = @quiz.components.first
    @user = User.find(params[:response][:user_id])
    due = @user.memories.find_by_component_id(@component).due
    most_recent = @quiz.responses.last
    if(most_recent)
      if((most_recent.status == "correct") && (due < most_recent.created_at))
        flash[:error] = "You have already responded to this problem. Please rate your response."
        redirect_to most_recent
        return
      elsif((due - Time.now) > 0)
        flash[:error] = "You have already responded to that problem. Please wait until it is due before answering again"
        redirect_to most_recent
        return
      end
    end

    # Create a new response
    @response = Response.new(params[:response])
    @response.user = current_user
     
    if @response.save
      redirect_to @response
    else
      flash[:error] = "Apologies, there was an error and your response was not saved."
      redirect_to course_study_index_path(@course)
    end
  end

  def update
  end

  def show
    @response = Response.find(params[:id])
    @answer_output = JSON.parse(@response.quiz.answer_output)
    @answer_type = @response.quiz.answer_type
    @course = @response.quiz.problem.course
  end

  def index
  end

end
