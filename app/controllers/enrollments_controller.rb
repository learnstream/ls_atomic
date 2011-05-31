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
    
    if params['teacher']
      @enrollment.role = "teacher"
    elsif params['student']
      @enrollment.role = "student" unless (current_user != @enrollment.user && current_user.perm != "admin")
    elsif params.nil? == false 
      # FIXME: Tests are updating parameters in a different manner from what is actually sent
      # from the view.  
      newrole = params[:enrollment][:role]
      if (newrole == "teacher" || current_user == @enrollment.user)
        @enrollment.role = newrole
      end
    end

    if @enrollment.save
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
