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
      flash[:notice] = "You're not logged in!"
      redirect_to new_user_session_path
      return false
    end
  end

  def signed_in?
    !current_user.nil?
  end
end
