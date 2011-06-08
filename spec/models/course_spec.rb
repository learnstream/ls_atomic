require 'spec_helper'

describe Course do
  before(:each) do
    @course = Factory(:course)
  end
  
  describe "enrollments" do

    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:admin)
    end

    it "should have an enrollments method" do
      @course.should respond_to(:enrollments)
    end

    it "should have a users method" do
      @course.should respond_to(:users)
    end
    
    it "should have a students method" do
      @course.should respond_to(:students)
    end

    it "should have a teachers method" do
      @course.should respond_to(:teachers)
    end

    it "should have a student enrollments method" do
      @course.should respond_to(:student_enrollments) 
    end

    it "should have the correct enrollments in the enrollments method" do
      @user.enroll!(@course)
      @admin.enroll_as_teacher!(@course)
      @course.student_enrollments.should include(@course.enrollments.find_by_user_id(@user))
      @course.student_enrollments.should_not include(@course.enrollments.find_by_user_id(@admin))
    end

    it "should include enrolled user in the users array" do
      @user.enroll!(@course)
      @course.users.should include(@user)
    end
  end
end
