class PagesController < ApplicationController
  def home
    if not signed_in?
      redirect_to root_path
      return
    end
    @taught_courses = current_user.taught_courses
    @studied_courses = current_user.studied_courses
  end

  def welcome
    if signed_in?
      redirect_to :home
    end
  end

  def about
  end

  def help
  end

end
