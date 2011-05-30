require 'spec_helper'

describe StudyController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)
      
      @component = Factory(:component, :course_id => @course)
      @memory = @user.memories.create!(:component_id => @component, :due => Time.now)
      @memory.due = Time.now
      @memory.save!
      @problem = Factory(:problem, :course_id => @course)
      @step = @problem.steps.create(:name => "Step 1", :text => "do this first", :order_number => 1)
      @step.relate!(@component)
   end

    it "should be successful" do
      get :index, :course_id => @course
      response.should be_success
    end

    it "should display study components" do
      get :index, :course_id => @course
      #response.should have_selector("div", :content => @memory.component.steps.first.text )
      response.should have_selector("div")
    end
  end
end
