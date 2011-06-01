require 'spec_helper'

describe ProblemsController do
  render_views

  describe "POST 'create'" do

    before(:each) do
      @course = Factory(:course)
      @attr = { :name => "Problem 1", :statement => "What is 2 + 5?", :course_id => @course.id }
    end

    describe "generic failure" do
      
      before(:each) do
        @user = test_sign_in(Factory(:admin))
      end

      it "should not create a problem with a blank statement" do
        lambda do
          post :create, :problem => @attr.merge(:statement => "")
        end.should change(Problem, :count).by(0)
      end  
    end

    describe "for students" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not create a problem" do
        lambda do
          post :create, :problem => @attr.merge(:course_id => @course)
        end.should_not change(Problem, :count)
      end
    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should create a problem" do
        lambda do
          post :create, :problem => @attr.merge(:course_id => @course)
        end.should change(Problem, :count).by(1)
      end
    end

    describe "for admin" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should create a problem" do
        lambda do
          post :create, :problem => @attr.merge(:course_id => @course)
        end.should change(Problem, :count).by(1)
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:admin)
      @course = Factory(:course)
      @problem = Factory(:problem)
    end

    it "should be success" do
      test_sign_in(@user)
      get :show, :id => @problem
      response.should be_success 
    end 

    it "should have an 'edit' link for admins" do
      test_sign_in(@admin)
      get :show, :id => @problem
      response.should have_selector("a", :content => "Edit")
    end

    it "should have an 'edit' link for teachers" do
      test_sign_in(@user)
      @user.enroll_as_teacher!(@course)
      get :show, :id => @problem
      response.should have_selector("a", :content => "Edit")
    end

    it "should not have an 'edit' link for students" do
      test_sign_in(@user)
      get :show, :id => @problem
      response.should_not have_selector("a", :content => "Edit")
    end 
  end

  describe "PUT 'update'" do

    before(:each) do
      @course = Factory(:course)
      @problem = Factory(:problem, :course_id => @course.id)
    end

    describe "for authorized users" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should not update to a blank statement" do
        old_problem_statement = @problem.statement
        put :update, :id => @problem, :problem => { :statement => "" }
        @problem.reload
        @problem.statement.should == old_problem_statement
      end

      it "should properly update the name" do
        put :update, :id => @problem, :problem => { :name => "NEWNAME!!", :statement => @problem.statement }
        @problem.reload
        @problem.name.should == "NEWNAME!!"
      end

      it "should properly update the problem statement" do
        put :update, :id => @problem, :problem => {:name => @problem.name, :statement => "New statement" }
        @problem.reload
        @problem.statement.should == "New statement"
      end
    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should also update the changes" do
        put :update, :id => @problem, :problem => { :name => "NEWNAME!!", :statement => @problem.statement }
        @problem.reload
        @problem.name.should == "NEWNAME!!"
      end
    end

    describe "for students" do
   
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not update the changes" do
        put :update, :id => @problem, :problem => { :name => "NEWNAME!!", :statement => @problem.statement }
        @problem.reload
        @problem.name.should_not == "NEWNAME!!"
      end
    end
  end  

  describe "GET 'show_step'" do

    before(:each) do 
      @user = Factory(:user)
      @course = Factory(:course)
      test_sign_in(@user)
      @user.enroll!(@course)
      @problem = Factory(:problem)
      @step = Factory(:step, :problem_id => @problem, :text => "hello")
    end

    it "should return json with the step text" do
      @expected = {
        :id => @step.id,
        :text => @step.text
      }.to_json

      get :show_step, :id => @problem, :step_number => 1 
      response.body.should == @expected 
    end
  end

  describe "GET 'edit'" do

    describe "for admins" do
      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
        @problem = Factory(:problem)
      end

      it "should be successsful" do
        get 'edit', :id => @problem
        response.should be_success
      end
    end

    describe "for students" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @course = Factory(:course)
        @user.enroll!(@course)
        @problem = Factory(:problem)
      end

      it "should deny access to edit" do
        get 'edit', :id => @problem
        response.should_not be_success
      end
    end
  end
end
