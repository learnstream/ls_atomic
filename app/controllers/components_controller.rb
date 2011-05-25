class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy ]
  def create
    @component = Component.new(params[:user])
    if @component.save
      flash[:success] = "Knowledge component created!"
      redirect_to ":list"
    else
      render "db"
    end
    
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
