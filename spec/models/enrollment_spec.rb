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

    it "should have a memories attribute" do
      @enrollment.should respond_to(:memories)
    end

    it "should have the right memories" do
      @component = Factory(:component, :course_id => @course)
      @enrollment.memories.first.should == @component.memories.find_by_user_id(@user)
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

  describe "for courses with existing component" do

    before(:each) do
      @component = Factory(:component, :course_id => @course)
    end

    describe "for students" do

      before(:each) do
        @enrollment.role = "student"
        @enrollment.save
      end

      it "should create memories for each the course components" do
        @user.memories.find_by_component_id(@component).should_not be_nil
      end
    end

    describe "for teachers" do

      before(:each) do 
        @enrollment.role = "teacher"
        @enrollment.save
      end

      it "should not create memories" do
        @user.memories.find_by_component_id(@component).should be_nil
      end
    end
  end
end
