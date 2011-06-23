require 'spec_helper'

describe "Doing exercises" do

  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @user.enroll!(@course)

    @component = Factory(:component, :course => @course)
    @quiz = Factory(:quiz, :course => @course)
    @quiz.components << @component

    integration_sign_in(@user) 
    visit course_study_index_path(@course)
  end

  it "should be accessible from the course page" do
    visit course_path(@course)
    click_link "Study"
    page.should have_content("Studying #{@course.name}")
  end

  it "should show the question" do
    page.should have_css("div", :content => @quiz.question)
  end

  it "should have a Check Answer button" do
    page.should have_css("a", :content => "Check answer")
  end

  it "should be skippable" do
    click_button "Skip"
    page.should have_css("p", :text => "Nothing is due")
  end
  
  it "should let the user say they don't know" do
    click_button "Don't Know"
    page.should have_css("#judgement")
  end

  it "should redirect to responses for questions that aren't due" do
    fill_in :input, :with => @quiz.answers.first.text
    click_button "Check answer"
    click_link "Easy"

    visit quiz_path(@quiz)
    page.should have_css("#judgement")
  end


  describe "for text input questions" do

    before(:each) do
      @quiz.answer_input = '{ "type" : "text" }'
      @quiz.save 
    end

    it "should have a box for text input" do
      visit course_study_index_path(@course)
      page.should have_css("input#response_answer")
    end
  end

  describe "for force diagram questions" do

    before(:each) do
      @quiz.answer_input = '{ "type" : "fbd" }'
      @quiz.save
    end

    it "should have a canvas for selecting the force" do
      visit course_study_index_path(@course)
      page.should have_css("#holder")
    end
  end

  describe "for self-rated questions" do

    before(:each) do
      @quiz.answer_input = '{ "type" : "self-rate" }'
      @quiz.save
    end

    it "should not have a box for text input" do
      visit course_study_index_path(@course)
      page.should_not have_css("input#response_answer")
    end
  end

  describe "after submitting the response" do

    it "should show the correct answer" do
      visit course_study_index_path(@course)
      fill_in :input, :with => "41"
      click_button "Check answer"
      page.should have_content("42")
    end

    it "should display help for the problem" do
      visit course_study_index_path(@course)
      fill_in :input, :with => "41"
      click_button "Check answer"
      page.should have_css("div#help")
    end

    describe "for text input" do

      describe "for correct answers" do

        it "should say the answer was correct" do 
          visit course_study_index_path(@course)
          fill_in :input, :with => "42"
          click_button "Check answer"
          page.should have_content("correct")
        end

        it "should have a self rating panel" do
          visit course_study_index_path(@course)
          fill_in :input, :with => @quiz.answers.first.text
          click_button "Check answer"
          page.should have_css("a#rate-hard")
          page.should have_css("a#rate-good")
          page.should have_css("a#rate-easy")
        end

        it "should not allow the user to select a miss" do
          visit course_study_index_path(@course)
          fill_in :input, :with => @quiz.answers.first.text
          click_button "Check answer"
          page.should_not have_css("a#rate-miss")
        end
      end

      describe "for incorrect answers" do 

        it "should say the answer was incorrect" do
          visit course_study_index_path(@course)
          fill_in :input, :with => "wrong asnwfaerw"
          click_button "Check answer"
          page.should have_content("incorrect")
        end

        it "should have a next button" do
          visit course_study_index_path(@course)
          fill_in :input, :with => "wrong asnwfaerw"
          click_button "Check answer"
          page.should have_content("Next")
        end
      end
    end

    describe "for self-rating" do

      before(:each) do
        @quiz.answer_input = '{ "type" : "self-rate" }'
        @quiz.save
      end

      it "should not judge the answer" do
        visit course_study_index_path(@course)
        click_button "Check answer"
        page.should_not have_css("p.flash")
      end

      it "should have a full self rating panel" do
        visit course_study_index_path(@course)
        click_button "Check answer"
        page.should have_css("a#rate-miss")
        page.should have_css("a#rate-hard")
        page.should have_css("a#rate-good")
        page.should have_css("a#rate-easy")
      end
    end
  end

  describe "rating panel" do
    it "should not appear for users who have already rated their response" do
      visit course_study_index_path(@course)
      fill_in :input, :with => @quiz.answers.first.text
      click_button "Check answer"
      click_link "Good"

      visit quiz_path(@quiz)
      page.should_not have_css("a", :text => "Good")
    end

    it "should redirect to the study page for the course" do
      visit course_study_index_path(@course)
      fill_in :input, :with => @quiz.answers.first.text
      click_button "Check answer"
      click_link "Good"
      page.should have_content("Studying " + @course.name)
    end
  end
end
