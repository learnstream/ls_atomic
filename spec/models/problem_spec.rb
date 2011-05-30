require 'spec_helper'

describe Problem do

  before(:each) do
    @course = Factory(:course)
    @attr = { :name => "Problem 1", :statement => "What is 2 + 5?", :course_id => @course.id }
  end
  
  describe "failure" do
    it "should require a name" do
      no_name_problem = Problem.new(@attr.merge(:name => ""))
      no_name_problem.should_not be_valid
    end

    it "should reject a name that is too long" do
      long_name = "a" * 135
      long_name_problem = Problem.new(@attr.merge(:name => long_name))
      long_name_problem.should_not be_valid
    end
    
    it "should require a course id" do
      no_course_problem = Problem.new(@attr.merge(:course_id => ""))
      no_course_problem.should_not be_valid
    end


  end

end
