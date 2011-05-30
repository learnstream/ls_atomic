require 'spec_helper'

describe StepsController do

  before(:each) do
    @user = test_sign_in(Factory(:user))
    @course = Factory(:course)
  end

  describe "POST 'create'" do

    before(:each) do
      @problem = Factory(:problem, :course_id => @course.id)
      @attr = { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
    end
    
    it "should create a step correctly" do
      lambda do
        post :create, :step => @attr 
      end.should change(Step, :count).by(1)
    end

    it "should associate step with a particular problem" do
      post :create, :step => @attr
      @problem.reload
      @problem.steps.length.should == 1
    end
  
    it "should re-render the problem template" do
      post :create, :step => @attr
      response.should redirect_to(@problem) 
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @step = Factory(:step)
    end

    it "should not update to blank text" do
      old_step = @step.text
      put :update, :id => @step, :step => { :text => "" }
      @step.reload
      @step.text.should == old_step
    end

    it "should properly update the name" do
      put :update, :id => @step, :step => { :name => "NEWNAME!!", :text => @step.text }
      @step.reload
      @step.name.should == "NEWNAME!!"
    end

    it "should properly update the step text" do
      put :update, :id => @step, :step => {:name => @step.name, :text => "New text" }
      @step.reload
      @step.text.should == "New text"
    end

    it "should properly update the order number" do
      put :update, :id => @step, :step => {:name => @step.name, :text => @step.text, :order_number => 2}
      @step.reload
      @step.order_number.should == 2
    end
  end  
end
