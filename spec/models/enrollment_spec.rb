require 'spec_helper'

describe Enrollment do

  before(:each) do
      @course = Factory(:course)
      @user = Factory(:user)

      @enrollment = @user.enrollments.build(:course_id => @course.id)
  end

  it "should create a new instance given valid attributes" do
    @enrollment.save!
  end

  describe "enrollment methods" do

    before(:each) do 
      @enrollment.save
    end

    it "should have a user attribute" do
      @enrollment.should respond_to(:user)
    end

    it "should have the right user" do
      @enrollment.user.should == @user
    end

    it "should have course attribute" do
      @enrollment.should respond_to(:course)
    end

    it "should have the right course" do
      @enrollment.course.should == @course
    end
  end

  describe "validations" do

    it "should require a user_id" do
      @enrollment.user_id = nil
      @enrollment.should_not be_valid
    end

    it "should require a course_id" do
      @enrollment.course_id = nil 
      @enrollment.should_not be_valid
    end

    it "should require roles" do
      @enrollment.role = nil 
      @enrollment.should_not be_valid
    end


  end
end
