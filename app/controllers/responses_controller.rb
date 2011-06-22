class ResponsesController < ApplicationController
  layout "study", :only => [:show]
  
  def create

    @response = Response.new(params[:response])
    @response.user = current_user

    if params[:commit] == "Skip"
      @response.status = "skipped"
    elsif params[:commit] == "Don't Know"
      @response.answer = "(unanswered)"
    end

    if @response.save
      if @response.status == "skipped"
        @course = @response.quiz.course
        redirect_to course_study_index_path(@course)
      else 
        redirect_to @response
      end
    else
      flash[:error] = "Apologies, there was an error and your response was not saved."
      redirect_to course_study_index_path(@course)
    end
  end

  def update
    @response = Response.find(params[:id])
    @response.rate_components!(Integer(params[:quality]))
    @course = @response.quiz.course

    if @response.save
      respond_to do |format|
        format.html { redirect_to course_study_index_path(@course) }
        format.json  
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Your response could not be rated."
          redirect_to course_study_index_path(@course)
        }
        format.json 
      end
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
