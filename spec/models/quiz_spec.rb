require 'spec_helper'

describe Quiz do
  
  before(:each) do
    @course = Factory(:course)
    @problem = Factory(:problem, :course_id => @course)
    @component = Factory(:component, :course_id => @course)
    @quiz = Factory(:quiz, :problem_id => @problem)
  end

  it "should have a problem method" do
    @quiz.should respond_to(:problem)
  end

  it "should have a quiz components method" do
    @quiz.should respond_to(:quiz_components)
  end

  it "should have a components method" do
    @quiz.should respond_to(:components)
  end

  it "should have a responses method" do
    @quiz.should respond_to(:responses)
  end

  it "should have a course method" do
    @quiz.should respond_to(:course)
  end

  it "should have the right course" do
    @quiz.course.should == @course
  end
end
