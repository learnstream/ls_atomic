class ResponsesController < ApplicationController
  layout "study", :only => [:show]
  
  def create
    @quiz = Quiz.find(params[:response][:quiz_id])
    @user = User.find(params[:response][:user_id])
    @course = @quiz.course

    # Look through all the components to make sure that at least one is due,
    # and that it has already been self-rated.
    notdue = true
    notrated = false
    most_recent = @quiz.responses.last
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
      if(notrated)
        flash[:error] = "You have already responded to this problem. 
                         Please rate your response."
      else
        flash[:error] = "You have already responded to that problem
                         Please wait until it is due before answering again"
      end
      redirect_to most_recent
      return
    end

    # Create a new response. Finally!
    @response = Response.new(params[:response])
    @response.user = current_user
    @response.quiz = @quiz
     
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
    @answer_type = @response.quiz.answer_type

    @answer_output_view = nil
    
    if @answer_type == "fbd"
      @answer_output_view = "fbd"
    end
  
    @course = @response.quiz.course
  end

  def index
  end

end
