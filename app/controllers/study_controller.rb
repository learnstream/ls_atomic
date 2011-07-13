class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])

    @quiz = Quiz.exercises.unlocked(@course.id, current_user.id).due(@course.id, current_user.id).sample

    if @quiz
      redirect_to course_study_path(@course, @quiz)
      return
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
