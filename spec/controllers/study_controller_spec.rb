require 'spec_helper'

describe StudyController do
  render_views

  before(:each) do
    @user = Factory(:user)
    test_sign_in(@user)
    @course = Factory(:course)

    @user.enroll!(@course)
    
    @component = Factory(:component, :course => @course)
    @quiz = Factory(:quiz, :course => @course)
    @quiz.components << @component
    @memory = @user.memories.find_by_component_id(@component)
    @memory.view(4)
    @memory.due = Time.now - 15.minutes
    @memory.save!
  end

  describe "GET 'index'" do


    it "should pull up quizzes with a due component" do
      get :index, :course_id => @course
      response.should redirect_to course_study_path(@course, @quiz)
    end

    it "should not pull up quizzes that are in a lesson" do
      @quiz.in_lesson = true
      @quiz.save!
      get :index, :course_id => @course
      response.should have_selector("div", :content => "Nothing is due")
    end

    it "should find the first component that contains a quiz" do
      @component2 = Factory(:component, :name => "Another component", :course => @course)
      @memory2 = @user.memories.find_by_component_id(@component2)
      @memory2.view(3)
      @memory2.due = Time.now - 1.day
      get :index, :course_id => @course
      response.should redirect_to course_study_path(@course, @quiz)
    end

    describe "when nothing is due" do

      it "should display a friendly message" do
        @memory.due = Time.now + 1.year
        @memory.save!
        get :index, :course_id => @course
        response.should have_selector("div", :content => "Nothing is due")
      end
    end
  end

  describe "GET 'show'" do

    it "should be successful" do
      get :show, :course_id => @course, :id => @quiz
      response.should be_success
    end
  end
end
