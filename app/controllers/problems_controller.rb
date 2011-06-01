class ProblemsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update, :new, :edit] do 
   check_permissions(params)
  end

 
  def create
    course_id = params[:problem][:course_id]
    if course_id.nil?
      flash[:error] = "If you know what's good, add a course. I have no idea what you did"
      redirect_to root_path
    else
      course = Course.find(course_id)
      @problem = course.problems.build(params[:problem])

      if @problem.save
        flash[:success] = "Problem created!"
        redirect_to @problem
      else
        flash[:error] = "There was a problem saving. Try again, or not."
        redirect_to course_path(course_id)
      end   
    end

 end

  def new
   @problem = Problem.new  
  end

  def update
    @problem = Problem.find(params[:id])
    @problem.name = params[:problem][:name]
    @problem.statement = params[:problem][:statement]
    if @problem.save
      flash[:success] = "Problem updated!"
      redirect_to problem_path
    else
      flash[:error] = "You fucked up!" #change...?
      redirect_to problem_path
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
      course ||= Course.find(params[:problem][:course_id]) 

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end
end