require 'spec_helper'

describe "StudyQuizzes" do

  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)

    @component = Factory(:component, :course_id => @course)
    @memory = @user.memories.create!(:component_id => @component)
    @memory.due = Time.now.utc
    @memory.save!

    @problem = Factory(:problem, :course_id => @course)
    @step1 = @problem.steps.create(:text => "do this first", :order_number => 1)
    @step2 = @problem.steps.create(:text => "do this next", :order_number => 2) 
    @step3 = @problem.steps.create(:text => "finally do this", :order_number => 3)

    @quiz = Factory(:quiz, :problem_id => @problem)
    @quiz.steps = ["1", "2"]
 
    integration_sign_in(@user) 
  end

  it "should be accessible from the course page" do
    visit course_path(@course)
    click_link "Study"
    page.should have_content("Studying #{@course.name}")
  end

  describe "in study mode" do
    before(:each) do
      visit course_study_index_path(@course)
    end

    it "should show the question" do
      page.should have_css("p", :content => @quiz.question)
    end

    it "should show the appropriate steps" do
      page.should have_css("li", :content => @step1.text)
      page.should have_css("li", :content => @step2.text)
    end

    it "should show the problem" do
      page.should have_css("p", :content => @problem.statement)
    end

    it "should have a Check Answer button" do
      page.should have_css("a", :content => "Check answer")
    end

    describe "for text input questions" do

      before(:each) do
        @quiz = Factory(:text_quiz, :problem_id => @problem)
      end

      it "should have a box for text input" do
        page.should have_css("input", :id => "response_answer",
                             :type => "text") 
      end
    end

    describe "for self-rated questions" do

      before(:each) do
        @quiz = Factory(:self_rate_quiz, :problem_id => @problem)
      end

      it "should not have a box for text input" do
        page.should_not  have_css("input", :id => "response_answer",
                             :type => "text") 
      end
    end

    describe "after revealing the answer" do
      it "should have a self rating panel"
    end
  end
end
