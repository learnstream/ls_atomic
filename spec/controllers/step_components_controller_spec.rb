require 'spec_helper'

describe StepComponentsController do

  describe "POST 'create'" do

    before(:each) do  
      @course = Factory(:course)
      @problem = Factory(:problem)  
      @step = Factory(:step, :problem_id => @problem.id)
      @component = Factory(:component, :course_id => @course.id)
    end

    describe "for admins" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
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
        response.should redirect_to edit_step_path(@step.id) 
      end
    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
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
        response.should redirect_to edit_step_path(@step.id) 
      end
    end

    describe "for students" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not create a step-component relationship" do
        lambda do
          post :create, :step_component => { :step_id => @step.id, :component_id => @component.id }
        end.should_not change(StepComponent, :count)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do  
      @course = Factory(:course)
      @problem = Factory(:problem)  
      @step = Factory(:step, :problem_id => @problem.id)
      @component = Factory(:component, :course_id => @course.id)
      @step.relate!(@component)
    end


    describe "for admins" do

      before(:each) do  
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should delete the step-component relationship" do
        step_component_id = @step.step_components[0].id
        lambda do
          delete :destroy, :id => step_component_id, :step_component => { :step_id => @step.id, 
                                                                          :component_id => @component.id }
        end.should change(StepComponent, :count).by(-1)
        response.should redirect_to edit_step_path(@step.id) 
      end
    end

    describe "for teachers" do

      before(:each) do  
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should delete the step-component relationship" do
        step_component_id = @step.step_components[0].id
        lambda do
          delete :destroy, :id => step_component_id, :step_component => { :step_id => @step.id, 
                                                                          :component_id => @component.id }
        end.should change(StepComponent, :count).by(-1)
        response.should redirect_to edit_step_path(@step.id) 
      end
    end


    describe "for students" do

      before(:each) do  
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not delete the step-component relationship" do
        step_component_id = @step.step_components[0].id
        lambda do
          delete :destroy, :id => step_component_id, :step_component => { :step_id => @step.id, 
                                                                          :component_id => @component.id }
        end.should_not change(StepComponent, :count)
        response.should redirect_to root_path 
      end
    end
  end
end
