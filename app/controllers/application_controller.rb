require "authlogic"
class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user, :signed_in?

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  def authenticate
    unless current_user
      deny_access
      return false
    end
  end

  def enrolled
    if not current_user.enrolled?(@course)
      flash[:error] = "You must be enrolled in the course to do that!"
      redirect_to root_path
    elsif current_user.teacher?(@course)
      flash[:error] = "You are a teacher in this course. You must be a student to study or watch lessons."
      redirect_to course_path(@course)
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    activate_authlogic
    UserSession.create(user)
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page"
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end

