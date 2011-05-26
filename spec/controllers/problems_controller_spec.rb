require 'spec_helper'

describe ProblemsController do

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @attr = { :name => "Problem 1", :statement => "What is 2 + 5?" }
    end

    describe "failure" do
      it "should not create a problem with a blank name" do
        lambda do
          post :create, :problem => @attr.merge(:name => "")
        end.should change(Problem, :count).by(0)
      end  
    end

    describe "success" do
      it "should create a problem" do
        lambda do
          post :create, :problem => @attr
          response.should redirect_to problem_path
        end.should change(Problem, :count).by(1)
      end
    end

  end


end
