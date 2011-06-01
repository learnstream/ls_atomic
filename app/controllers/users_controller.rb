class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :update, :courses] 

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Learnstream"
      redirect_to root_path
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])   
  end

  def index
    @title = "All users"
    @users = User.all
  end

  def update
    if params[:user][:perm]
      if is_admin?
        user = User.find(params[:id])
        user.perm = params[:user][:perm]
        user.save

        flash[:success] = "Changed user role!"
        redirect_to users_path 
      else
        flash[:error] = "You don't have permission to do that!"
        redirect_to @current_user
      end
    end
  end

  def courses
    @title = "Courses"
    @user = User.find(params[:id])
    @courses = @user.courses.paginate(:page => params[:page])
    render 'show_courses'
  end

  private
    def is_admin? 
      @current_user.perm == "admin"
    end
end
