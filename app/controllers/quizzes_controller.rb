class QuizzesController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update, :new, :edit] do
    check_permissions(params)
  end

  def new 
    @problem = Problem.find(params[:problem_id])
    @quiz = Quiz.new
  end

  def create 
   problem = Problem.find(params[:quiz][:problem_id])
   course = problem.course

   if problem.nil?
     flash[:error] = "You're trying to add a quiz to a problem that doesn't exist"
     redirect_to root_path
     return
   end 

   @quiz = problem.quizzes.build(params[:quiz])
   @quiz.answer_input = params[:quiz][:answer_type]
   @quiz.answer_output = params[:quiz][:answer_type]

   if @quiz.save
     flash[:success] = "Quiz created!"
     redirect_to course
   else
     @problem = problem
     render 'new'
   end
  end

  private 
  
    def check_permissions(params)

      course = Quiz.find(params[:id]).course unless params[:id].nil?
      course ||= Problem.find(params[:problem_id]).course unless params[:problem_id].nil?
      course ||= Problem.find(params[:quiz][:problem_id]).course unless params[:quiz].nil? or params[:quiz][:problem_id].nil?

      if course.nil? 
        flash[:error] = "Try going to the course page to create a quiz"
        redirect_to root_path
        return false
      end

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permission to edit this course"
        redirect_to root_path
        return false
      end
    end
end
