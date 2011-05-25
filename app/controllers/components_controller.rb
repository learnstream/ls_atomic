class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy ]
  def create
  end

  def destroy
  end

  def show
    @component = Component.find(params[:id])
    @title = @component.name
  end

  def list
    @components = Component.all
  end
end
