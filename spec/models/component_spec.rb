require 'spec_helper'

describe Component do
  before(:each) do
    @course = Factory(:course)
    @attr = { :name => "foo", :description => "bar" }
  end

  it "should have a name" do
    no_name_component = @course.components.create(@attr.merge(:name => "")) 
    no_name_component.should_not be_valid
  end    
  
  it "name should be unique" do
    @course.components.create(@attr)
    duplicate_component = @course.components.create(@attr)
    duplicate_component.should_not be_valid
  end  

  it "should have a course_id" do
    no_course_component = Component.new(@attr)
    no_course_component.should_not be_valid
  end

  describe "course associations" do

    before(:each) do
      @course = Factory(:course)
      @component = @course.components.create(@attr)
    end

    it "should have a course attribute" do
      @component.should respond_to(:course)
    end

    it "should have the right associated course" do
      @component.course_id.should == @course.id
      @component.course.should == @course
    end
  end

  describe "step-component relations" do

     before(:each) do
      @component = Factory(:component)
      @problem = Factory(:problem)
      @step = Factory(:step, :problem_id => @problem.id)       
    end
   
    it "should have a step_components method" do
      @component.should respond_to(:step_components)
    end

    it "should have a steps method" do
      @component.should respond_to(:steps)
    end

    it "should include the step in the steps array" do
      @step.relate!(@component)
      @component.steps.should include(@step)
    end 
  end

  describe "quiz associations" do
    before(:each) do
      @component = Factory(:component)
    end

    it "should have a quizzes method" do
      @component.should respond_to(:quizzes)
    end
  end
end

