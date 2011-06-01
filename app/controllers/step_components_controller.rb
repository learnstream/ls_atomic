class StepComponentsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :destroy] do
    check_permissions(params)
  end

  def create
    @step = Step.find(params[:step_component][:step_id])
    @component = Component.find(params[:step_component][:component_id])
    @step.relate!(@component)
    redirect_to edit_step_path(@step)
  end

  def destroy
    @step = Step.find(params[:step_component][:step_id])
    @component = Component.find(params[:step_component][:component_id])
    @step.unrelate!(@component)
    redirect_to edit_step_path(@step)
  end

  private

    def check_permissions(params)

      course = Component.find(params[:id]).course unless params[:id].nil? 
      course ||= Component.find(params[:step_component][:component_id]).course

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end
end
