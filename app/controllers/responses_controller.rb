class ResponsesController < ApplicationController
  def create
    @response = Response.new(params[:response])
    @response.user = current_user
     
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
