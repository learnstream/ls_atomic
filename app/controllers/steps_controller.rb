class StepsController < ApplicationController

  def create
    problem_id = params[:step][:problem_id]
    if problem_id.nil?
      flash[:error] = "Something went wrong... you need to add steps to problems!"
      redirect_to root_path
    else
      problem = Problem.find(problem_id)
      problem.steps.order_number
      @step = problem.step.build(params[:step], )
      @step = Step.create!(:name => params[:step][:name], :text => params[:step][:text])
      problem.steps << @step.id.to_s
      problem.save
    end
  end

  def new
  end

  def destroy
  end

  def update
  end

  def edit
  end

end
