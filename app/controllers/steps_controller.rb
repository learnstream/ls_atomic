class StepsController < ApplicationController

  def create
    problem_id = params[:step][:problem_id]
    if problem_id.nil?
      flash[:error] = "Something went wrong... you need to add steps to problems!"
      redirect_to root_path
    else
      problem = Problem.find(problem_id)
      if problem.steps.last.nil?
        largest_step_number = 0
      else
        largest_step_number = problem.steps.last.order_number
      end
      @step = problem.steps.build(params[:step].merge(:order_number => largest_step_number + 1 ))
      @step.save
      redirect_to problem_path(problem.id)
    end
  end


  def destroy
  end

  def update
  end

  def edit
  end

end
