require 'spec_helper'

describe Step do

  before(:each) do
    @attr = { :name => "Step 1", :text => "Think about it"}
  end
  
  describe "failure" do
    it "should require text" do
      no_text_step = Step.new(@attr.merge(:text => ""))
      no_text_step.should_not be_valid
    end

    it "should reject a name that is too long" do
      long_name = "a"*135
      long_name_step = Step.new(@attr.merge(:name => long_name))
      long_name_step.should_not be_valid
    end
    
    it "should reject order index that is negative" do
      step = Step.new(@attr.merge(:order_number => -1 ))
      step.should_not be_valid
    end
  end


  describe "step component relationships" do

    before(:each) do
      @problem = Factory(:problem)
      @step = Factory(:step, :problem_id => @problem.id) 
      @component = Factory(:component)
    end

    it "should have a step components relationship method" do
      @step.should respond_to(:step_components)
    end

    it "should have a components method" do
      @step.should respond_to(:components)
    end

    it "should have a related? method" do
      @step.should respond_to(:related?)
    end

    it "should have a relate! mehthod" do
      @step.should respond_to(:relate!)
    end

    it "should become related to a component" do
      @step.relate!(@component)
      @step.should be_related(@component)
    end

    it "should included the related component in components array" do
      @step.relate!(@component)
      @step.components.should include(@component)
    end
    
    it "should have an unrelate! method" do
      @step.should respond_to(:unrelate!)
    end

    it "should unrelate a component" do
      @step.relate!(@component)
      @step.unrelate!(@component)
      @step.should_not be_related(@component)
    end
  end
end
