require 'spec_helper'

describe StepsController do
  render_views

  describe "POST 'create'" do

    before(:each) do
      @course = Factory(:course)
      @problem = Factory(:problem, :course_id => @course.id)
      @attr = { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
    end

    describe "for authorized users" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
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

      it "should redirect to the edit step page" do
        post :create, :step => @attr
        @step = @problem.steps.first
        response.should redirect_to edit_step_path(@step)
      end

    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should also create a step" do
        lambda do
          post :create, :step => @attr
          #response.should be_valid
        end.should change(Step, :count).by(1)
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
          post :create, :step => @attr
        end.should_not change(Step, :count)
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @step = Factory(:step)
      @course = @step.problem.course
    end

    describe "for authorized users" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should not update to blank text" do
        put :update, :id => @step, :step => { :text => "" }
        @step.reload
        @step.text.should_not == ""
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

      it "should redirect to the edit problem page" do
        put :update, :id => @step, :step => {:name => @step.name, :text => "New text" }
        response.should redirect_to edit_problem_path(@step.problem)
      end
    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should properly update the changes" do
        put :update, :id => @step, :step => { :name => "NEWNAME!!", :text => @step.text }
        @step.reload
        @step.name.should == "NEWNAME!!"
      end
    end

    describe "for students" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not update the changes" do
        put :update, :id => @step, :step => { :name => "NEWNAME!!", :text => @step.text }
        @step.reload
        @step.name.should_not == "NEWNAME!!"
      end
    end
  end  

  describe "GET 'edit'" do

    before(:each) do
      @admin = Factory(:admin)
      test_sign_in(@admin)
      @step = Factory(:step)
    end 

    it "should have a link back to the problem" do
      get :edit, :id => @step
      response.should have_selector("a", :content => "Back to problem")
    end

  end

  describe "GET 'help'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @component1 = Factory(:component)
      @step = Factory(:step)
      @step.relate!(@component1)
    end

    it "should have links for the related components" do
      @expected = [{:name => @component1.name, :path => component_path(@component1)}].to_json
      get :help, :id => @step, :format => :json
      response.body.should == @expected
    end
  end
end
