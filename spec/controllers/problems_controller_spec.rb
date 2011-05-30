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

      it "should not create a problem with a blank name" do
        lambda do
          post :create, :problem => @attr.merge(:name => "")
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
          #response.should redirect_to problem_path 
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
          #response.should redirect_to problem_path 
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
          #response.should redirect_to problem_path 
        end.should change(Problem, :count).by(1)
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @course = Factory(:course)
      @problem = Factory(:problem)
    end

    it "should have the name of the problem" do
      get :show, :id => @problem
      response.should have_selector("h1", :content => @problem.name)
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

      it "should not update to a blank name" do
        old_problem = @problem.name
        put :update, :id => @problem, :problem => { :name => "" }
        @problem.reload
        @problem.name.should == old_problem
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
end
