require 'spec_helper'

describe Quiz do
  
  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @quiz = Factory(:quiz, :course => @course)
    @quiz.components << @component
  end

  it "should have a quiz components method" do
    @quiz.should respond_to(:quiz_components)
  end

  it "should have a components method" do
    @quiz.should respond_to(:components)
  end

  it "should have the right components" do
    @quiz.components.should include(@component)
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

  it "should be skippable, which skips each component" do
    @student = Factory(:user)
    @student.enroll!(@course)
    @quiz.skipped_by(@student)
    
    @student.memories.find_by_component_id(@component).should_not be_due
    @student.memories.find_by_component_id(@component).should be_viewed
  end
end
