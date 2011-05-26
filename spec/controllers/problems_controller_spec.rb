require 'spec_helper'

describe ProblemsController do
  render_views
  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @attr = { :name => "Problem 1", :statement => "What is 2 + 5?" }
      @course = Factory(:course)
    end

    describe "failure" do
      it "should not create a problem with a blank name" do
        lambda do
          post :create, :problem => @attr.merge(:name => "", :course_id => @course)
        end.should change(Problem, :count).by(0)
      end  
    end

    describe "success" do
      it "should create a problem" do
        lambda do
          post :create, :problem => @attr.merge(:course_id => @course)
          response.should redirect_to problem_path
        end.should change(Problem, :count).by(1)
      end
    end
  end

end
