require 'spec_helper'

describe StepComponent do

  before(:each) do
    @user = Factory(:user)
    @step = Factory(:step)
    @component = Factory(:component)
    @step_component = @step.step_components.build(:component_id => @component.id)
  end

  it "should create a new step component relationship" do
    @step_component.save!
  end

  describe "step-component methods" do

    before(:each) do
      @step_component.save
    end

    it "should have a step attribute" do
      @step_component.should respond_to(:step)
    end

    it "should have the right step" do
      @step_component.step.should == @step
    end

    it "should have a component attribute" do
      @step_component.should respond_to(:component)
    end

    it "should have the right component" do
      @step_component.component.should == @component
    end
  end
   
  describe "validations" do

    it "should require a step_id" do
      @step_component.step_id = nil
      @step_component.should_not be_valid
    end
 
    it "should require a component_id" do
      @step_component.component_id = nil
      @step_component.should_not be_valid
    end
  end 
end
