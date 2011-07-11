class EnrollmentsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:update] do
    check_permissions(params)
  end

  def create
    @course = Course.find(params[:enrollment][:course_id])
    current_user.enroll!(@course)
    redirect_to @course
  end

  def destroy
    @course = Enrollment.find(params[:id]).course
    current_user.unenroll!(@course)
    redirect_to courses_path
  end

  def update
        
    @enrollment = Enrollment.find(params[:id])
    @course = @enrollment.course

    # Restrict permissions
    if (not current_user.can_edit?(@course))
      flash[:error] = "You do not have permission to do that!"
      redirect_to @course
      return
    elsif (@enrollment.role == "teacher" && params[:enrollment][:role] == "student" && @enrollment.user != current_user && (not current_user.admin?))
      flash[:error] = "You cannot remove other teachers from the course!"
      redirect_to @course
      return
    end

    #update
    if @enrollment.update_attributes(params[:enrollment])
      redirect_to :controller => :courses, :id => @course, :action => :users
    else
      flash[:error] = "You did something wrong!"
      redirect_to @course 
    end
  end

  private

    def check_permissions(params)

      course = Enrollment.find(params[:id]).course unless params[:id].nil? 
      course ||= Course.find(params[:enrollment][:course_id])

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end

end
