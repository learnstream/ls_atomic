class QuizzesController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update, :new, :edit] do
    check_permissions(params)
  end

  def new 
    @problem = Problem.find(params[:problem_id])
    @quiz = Quiz.new
  end

  private 
  
    def check_permissions(params)

      course = Quiz.find(params[:id]).course unless params[:id].nil?
      course ||= Problem.find(params[:problem_id]).course unless params[:problem_id].nil?
      course ||= Course.find(params[:quiz][:course_id])

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permission to edit this course"
        redirect_to root_path
        return false
      end
    end
end
