class UsersController < ApplicationController

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Learnstream"
      redirect_to 'pages/home'
    else
      @title = "Sign up"
      render 'new'
    end
  end


end
