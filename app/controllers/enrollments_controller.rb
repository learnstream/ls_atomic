class EnrollmentsController < ApplicationController
  before_filter :authenticate

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
    elsif params.nil? == false 
      @enrollment.role = params[:enrollment][:role]
    end

    if @enrollment.save
      redirect_to @course
    else
      flash[:error] = "You did something wrong!"
      redirect_to @course 
    end
  end

end
