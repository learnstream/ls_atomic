class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])
    @memory = current_user.memories.course_exercise(@course).first

    if @memory.nil?
      render 'index'
      return
    end

    #Choose a random quiz
    @quiz = @memory.component.quizzes.exercises.sample
    if @quiz
      redirect_to course_study_path(@course, @quiz)
    else
      render 'index'
      return
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
end
