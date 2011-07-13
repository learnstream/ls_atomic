class StudyController < ApplicationController
  before_filter :authenticate
  before_filter :enrolled

  layout "study"

  def index
    @course = Course.find(params[:course_id])

    @quiz = Quiz.where(:in_lesson => false).where(:course_id => @course.id).joins(:components => :memories).where('memories.user_id = ?', current_user.id).merge(Memory.due_before(DateTime.now.utc)).sample

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
