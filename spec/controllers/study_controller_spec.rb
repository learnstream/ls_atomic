require 'spec_helper'

describe StudyController do
  render_views

  describe "GET 'index'" do

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

    describe "when nothing is due" do

      it "should display a friendly message" do
        @memory.due = Time.now + 1.year
        @memory.save!
        get :index, :course_id => @course
        response.should have_selector("div", :content => "Nothing is due")
      end
    end
  end
end
