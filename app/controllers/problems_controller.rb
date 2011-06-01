class ProblemsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update, :new, :edit] do 
   check_permissions(params)
  end
 
  def create
    course = Course.find(params[:problem][:course_id])
    if course.nil? 
      flash[:error] = "You're trying to add to a course that doesn't exist"
      redirect_to root_path
      return
    end

    @problem = course.problems.build(params[:problem])

    if @problem.save
      flash[:success] = "Problem created!"
      redirect_to @problem
    else
      @course = course
      render 'new'
    end
   end

  def new
    @course = Course.find(params[:course_id])
    @problem = Problem.new  
  end

  def update
    @problem = Problem.find(params[:id])

    if @problem.update_attributes(params[:problem])
      flash[:success] = "Problem updated!"
      redirect_to problem_path
    else
      @step = Step.new
      render 'edit' 
    end
  end

  def edit
    @problem = Problem.find(params[:id])
    @step = Step.new
  end

  def show
    @problem = Problem.find(params[:id])
    @steps = @problem.steps
    @course = @problem.course
  end

  def show_step
    @problem = Problem.find(params[:id])
    @step = @problem.steps[Integer(params[:step_number])-1]
    render :json => @step
  end

  private

    def check_permissions(params)

      course = Problem.find(params[:id]).course unless params[:id].nil? 
      course ||= Course.find(params[:course_id]) unless params[:course_id].nil?
      course ||= Course.find(params[:problem][:course_id]) 

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permission to do that!"
        redirect_to root_path
        return false
      end 
    end
end
