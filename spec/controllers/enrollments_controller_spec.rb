require 'spec_helper'

describe EnrollmentsController do

  describe "access control" do

    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)
    end

    it "should create an enrollment" do
      lambda do
        post :create, :enrollment => { :course_id => @course}
      end.should change(Enrollment, :count).by(1)
    end

    it "should redirect to the course page" do
      post :create, :enrollment => { :course_id => @course }
      response.should redirect_to @course
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)
      @user.enroll!(@course)
      @enrollment = @user.enrollments.find_by_course_id(@course)
    end

    it "should destroy an enrollment" do
      lambda do
        delete :destroy, :id => @enrollment
      end.should change(Enrollment, :count).by(-1)
    end

    it "should redirect to the courses page" do
      delete :destroy, :id => @enrollment
      response.should redirect_to courses_path
    end
  end
end

