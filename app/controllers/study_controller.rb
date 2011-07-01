class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])
    memories = current_user.memories.course_exercise(@course)

    memories.each do |memory|
      @quiz = memory.component.quizzes.exercises.sample
      if @quiz
        redirect_to course_study_path(@course, @quiz)
        return
      end
    end

    render 'index'
  end

  def show
    @quiz = Quiz.find(params[:id])
    @user = current_user
    @course = @quiz.course

    @response = Response.new

    respond_to do |format|
      format.html
      format.js 
    end
  end
end
