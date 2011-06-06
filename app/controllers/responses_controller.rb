class ResponsesController < ApplicationController
  def create
    @response = Response.new(params[:response])
    @response.user = current_user
     
    if @response.quiz.answer_type != "self-rate" 
      if @response.quiz.check_answer(@response) 
        @response.status = "correct"
      else
        @response.status = "incorrect"
        @response.quiz.rate_components!(@response.user, 0)
      end
    else
      @response.status = ""
    end

    if @response.save
      redirect_to @response
    else
      flash[:error] = "Apologies, there was an error and your response was not saved."
      redirect_to course_study_index_path
    end
  end

  def update
  end

  def show
    @response = Response.find(params[:id])
    @answer_output = JSON.parse(@response.quiz.answer_output)
    @answer_type = @response.quiz.answer_type
  end

  def index
  end

end
