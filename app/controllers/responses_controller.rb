class ResponsesController < ApplicationController
  layout "study", :only => [:show]
  
  def create
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
    @response = Response.find(params[:id])
    @response.rate_components!(Integer(params[:quality]))
    @response.has_been_rated = true
    @course = @response.quiz.course

    if @response.save
      redirect_to course_study_index_path(@course)
    else
      flash[:error] = "Your response could not be rated."
      redirect_to course_study_index_path(@course)
    end
  end

  def show
    @response = Response.find(params[:id])
    @quiz = @response.quiz
    @answer_type = @quiz.answer_type

    @answer_output_view = nil
    
    if @answer_type == "fbd"
      @answer_output_view = "fbd"
    end
  
    @course = @quiz.course
  end

  def index
  end

end
