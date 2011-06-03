require 'spec_helper'

describe QuizzesController do

  describe "GET 'new'" do

    before(:each) do
      @course = Factory(:course)
    end

    describe "for authorized users" do
      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should be successful" do
        get :new, :course_id => @course 
        response.should be_success
      end
    end

    describe "for students" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not be successful" do
        get :new, :course_id => @course
        response.should_not be_success
      end
    end
  end
end
