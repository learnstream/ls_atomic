require 'spec_helper'

describe StepsController do

  describe "POST 'create'" do

    before(:each) do
      @course = Factory(:course)
      @problem = Factory(:problem, :course_id => @course.id)
    end

   
    describe "for admins" do
      
      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end
    
      it "should create a step correctly" do
        lambda do
          post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
          #response.should be_valid
        end.should change(Step, :count).by(1)
      end

      it "should associate step with a particular problem" do
        post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
        @problem.reload
        @problem.steps.length.should == 1
      end
    
      it "should re-render the problem template" do
        post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
        response.should redirect_to(@problem) 
      end
    end

    describe "for teachers" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end
    
      it "should create a step correctly" do
        lambda do
          post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
          #response.should be_valid
        end.should change(Step, :count).by(1)
      end

      it "should associate step with a particular problem" do
        post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
        @problem.reload
        @problem.steps.length.should == 1
      end
    
      it "should re-render the problem template" do
        post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
        response.should redirect_to(@problem) 
      end
    end

    describe "for students" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end
    
      it "should not create a step" do
        lambda do
          post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
          #response.should be_valid
        end.should_not change(Step, :count)
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @step = Factory(:step)
      @course = @step.problem.course
    end

    describe "for admins" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
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

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
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


    describe "for students" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not update the name" do
        put :update, :id => @step, :step => { :name => "NEWNAME!!", :text => @step.text }
        @step.reload
        @step.name.should_not == "NEWNAME!!"
      end

      it "should not update the step text" do
        put :update, :id => @step, :step => {:name => @step.name, :text => "New text" }
        @step.reload
        @step.text.should_not == "New text"
      end

      it "should not update the order number" do
        put :update, :id => @step, :step => {:name => @step.name, :text => @step.text, :order_number => 2}
        @step.reload
        @step.order_number.should_not == 2
      end
    end
  end  


end
