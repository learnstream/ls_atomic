require 'spec_helper'

describe StepComponentsController do

  describe "POST 'create'" do

    before(:each) do  
      @user = test_sign_in(Factory(:user))
      @course = Factory(:course)
      @problem = Factory(:problem)  
      @step = Factory(:step, :problem_id => @problem.id)
      @component = Factory(:component, :course_id => @course.id)
    end
  
    it "should create a step-component relationship" do
      lambda do
        post :create, :step_component => { :step_id => @step.id, :component_id => @component.id }
      end.should change(StepComponent, :count).by(1)
    end

    it "should create the correct step-component relationship" do
      post :create, :step_component => { :step_id => @step.id, :component_id => @component.id }
      @step.step_components.first.component_id.should == @component.id 
      @component.step_components.first.step_id.should == @step.id
    end

    it "should redirect to the step show page" do
      post :create, :step_component => { :step_id => @step.id, :component_id => @component.id }
      response.should redirect_to @step
    end
  
  end

  describe "DELETE 'destroy'" do
    before(:each) do  
      @user = test_sign_in(Factory(:user))
      @course = Factory(:course)
      @problem = Factory(:problem)  
      @step = Factory(:step, :problem_id => @problem.id)
      @component = Factory(:component, :course_id => @course.id)
      @step.relate!(@component)
    end


    it "should delete the step-component relationship" do
      delete :destroy, :step_component => { :step_id => @step.id, :component_id => @component.id }
      response.should redirect_to @step
    end
  end

end
