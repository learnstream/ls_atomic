class ResponsesController < ApplicationController
  def create
    @response = Response.new(params[:response])
    @response.user = current_user
    if @response.quiz.check_answer(@response) 
      @response.status = "correct"
    else
      @response.status = "incorrect"
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
  end

  def index
  end

end
