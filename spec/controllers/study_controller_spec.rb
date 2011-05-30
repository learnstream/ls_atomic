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
    end

    describe "when nothing is due" do

      it "should display a friendly message when nothing is due" do
        @memory.due = Time.now + 1.year
        @memory.save!
        get :index, :course_id => @course
        response.should have_selector("div", :content => "Nothing is due")
      end
    end

    describe "generic problem study" do

      before(:each) do
        @problem = Factory(:problem, :course_id => @course)
        @step1 = @problem.steps.create(:text => "do this first", :order_number => 1)
        @step2 = @problem.steps.create(:text => "do this next", :order_number => 2) 
        @step2.relate!(@component)
        @step3 = @problem.steps.create(:text => "finally do this", :order_number => 3)
      end  

      it "should be successful" do
        get :index, :course_id => @course
        response.should be_success
      end

      it "should display the steps leading up to the tested step" do
        get :index, :course_id => @course
        response.should have_selector("div", :content => @problem.steps.first.text)
      end

      it "should not display later steps" do
        get :index, :course_id => @course
        response.should_not have_selector("div", :content => @problem.steps.last.text)
      end

      it "should ask the user for the next step" do
        get :index, :course_id => @course
        response.should have_selector("div", :content => "next step")
      end
      
      it "should have a button to reveal the next step" do
        get :index, :course_id => @course
        response.should have_selector("a", :content => "Show")
      end
    end

    describe "component studying" do
      
      it "should show the component description" do
        get :index, :course_id => @course
        response.should have_selector("div", :content => @component.description)
      end
    end 
  end
end
