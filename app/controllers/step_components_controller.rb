class StepComponentsController < ApplicationController
  def create
    @step = Step.find(params[:step_component][:step_id])
    @component = Component.find(params[:step_component][:component_id])
    @step.relate!(@component)
    redirect_to @step
  end

  def destroy
    @step = Step.find(params[:step_component][:step_id])
    @component = Component.find(params[:step_component][:component_id])
    @step.unrelate!(@component)
    redirect_to @step
  end

end
