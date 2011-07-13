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
end
