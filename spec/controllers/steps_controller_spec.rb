require 'spec_helper'

describe StepsController do

  before(:each) do
    @user = test_sign_in(Factory(:user))
    @course = Factory(:course)
    @problem = Factory(:problem, :course_id => @course.id)
  end

  describe "POST 'create'" do
    
    it "should create a step correctly" do
      lambda do
        post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
        response.should be_valid
      end.should change(Step, :count).by(1)
    end

    it "should associate with a particular problem" do
      post :create, :step => { :name => "Step 1", :text => "Do this first", :problem_id => @problem.id }
      @problem.reload
      @problem.steps.should include(1)
    end
  end

end
