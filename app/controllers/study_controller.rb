class StudyController < ApplicationController
  before_filter :authenticate
  before_filter :enrolled

  layout "study"

  def index
    @course = Course.find(params[:course_id])

    #@quiz = Quiz.exercises.unlocked(@course.id, current_user.id).due(@course.id, current_user.id).sample
    @memory = current_user.memories_due_with_quiz(@course).sample
    @quiz = @memory.nil? ? nil : Quiz.memory(@memory).sample

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

  def enrolled
    @course =  Course.find(params[:course_id]) if params[:course_id]
    if not current_user.enrolled?(@course)
      flash[:error] = "You must be enrolled in the course to study!"
      redirect_to root_path
    elsif current_user.teacher?(@course)
      flash[:error] = "You are a teacher in this course. You must be a student to study."
      redirect_to course_path(@course)
    end
  end

end
