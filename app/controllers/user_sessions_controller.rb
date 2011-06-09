class UserSessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy

  def new 
    @user_session = UserSession.new
    @title = "Sign in"
  end

  def create 
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to signin_path
  end
end
