class StepsController < ApplicationController

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
      redirect_to problem_path(problem_id)
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
    redirect_to problem_path(problem_id)

  end

  def edit
    @step = Step.find(params[:id])
    @components = @step.problem.course.components
  end

end
