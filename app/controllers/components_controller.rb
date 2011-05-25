class ComponentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy ]
  
  def create
    @component = Component.new(params[:component])
    if @component.save
      flash[:success] = "Knowledge component created!"
      redirect_to :db 
    else
      @components = Component.all
      render 'components/list' 
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
    @component = Component.new if signed_in?
  end
end
