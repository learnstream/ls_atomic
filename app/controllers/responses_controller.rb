class ResponsesController < ApplicationController
  layout "study", :only => [:show]
  
  def create

    @response = Response.new(params[:response])
    @response.user = current_user
    
    @course = @response.quiz.course

    if params[:commit] == "Skip"
      @response.status = "skipped"
    end

    if @response.save
      if @response.status == "skipped"
        respond_to do |format|
          format.html do 
            redirect_to course_study_index_path(@course)
          end
          format.js { render 'load_next', :format => :js }
        end 
      else 
        respond_to do |format|
          format.html { redirect_to @response }
          format.js { 
            render 'show', :format => :js 
          }
        end
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
        format.js { render 'update', :format => :js }
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
    @course = @response.quiz.course

    respond_to do |format|
      format.html { render 'show' }
      format.js { render 'show', :format => :js }
    end
  end

  def index
  end

end
