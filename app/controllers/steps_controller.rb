class StepsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update] do 
   check_permissions(params)
  end

  def create
    problem_id = params[:step][:problem_id]
    if problem_id.nil?
      flash[:error] = "Something went wrong... you need to add steps to problems!"
      redirect_to root_path
      return
    else
      problem = Problem.find(problem_id)
      if problem.steps.last.nil?
        largest_step_number = 0
      else
        largest_step_number = problem.steps.last.order_number
      end
      @step = problem.steps.build(params[:step].merge(:order_number => largest_step_number + 1 ))
      @step.save
      flash[:success] = "Step created!"
      redirect_to edit_step_path(@step)
    end
  end

  def destroy
  end

  def update
    step = Step.find(params[:id])
    name = params[:step][:name]
    text = params[:step][:text]
    order_number = params[:step][:order_number]
    problem_id = step.problem_id 

    step.name = name
    step.order_number = order_number unless order_number.nil?
    if text.blank?
      flash[:error] = "You can't have a blank step! Delete it if you dare...."
      redirect_to problem_path(problem_id) 
      return
    else
      step.text = text
    end
    step.save
    flash[:success] = "Step updated!"
    redirect_to edit_problem_path(step.problem)
  end

  def edit
    @step = Step.find(params[:id])
    @components = @step.problem.course.components
  end

  private

    def check_permissions(params)

      course = Step.find(params[:id]).problem.course unless params[:id].nil? 
      course ||= Problem.find(params[:step][:problem_id]).course 

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end

end
