require 'spec_helper'

describe "Doing exercises" do

  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @user.enroll!(@course)

    @component = Factory(:component, :course => @course)
    @memory = @user.memories.find_by_component_id(@component)
    @memory.views += 1 #simulate appearance in a lesson
    @memory.last_viewed = DateTime.now  #simulate appearance in a lesson
    @memory.due = DateTime.now - 1.day
    @memory.save!

    @quiz = Factory(:quiz, :course => @course)
    @quiz.components << @component
    @answer = Factory(:answer)
    @quiz.answers << @answer

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

  it "should have a Don't know button before an answer is typed" do
    page.should have_css('input[value="Don\'t know"]')
  end

  it "should have a Check Answer button once something is typed", :js => true do
    fill_in :input, :with => "asdf"
    page.should have_css('input[value="Check answer"]')
  end

  it "should be skippable" do
    click_button "Skip"
    page.should have_css("p", :text => "Nothing is due")
  end
  
  it "should let the user say they don't know" do
    click_button "Don't know"
    page.should have_css("#judgement")
  end

  it "should show the information about the last component studied" do
    click_button "Skip"
    @component2 = Factory(:component, :name => "Another componet", :course => @course)
    @memory2 = @user.memories.find_by_component_id(@component2)
    Timecop.travel(DateTime.now.utc - 3.days) do 
      @memory2.view(0)
      @memory2.save!
    end
    @quiz2 = Factory(:quiz, :course => @course)
    @quiz2.components << @component2
    @answer2 = Factory(:answer)
    @quiz2.answers << @answer2

    visit course_study_index_path(@course)
    page.should have_content(@quiz2.question)
    page.should have_css("a", :text => @component.name)
  end

  describe "when the quiz has an event" do

    before(:each) do
      @event = Factory(:event)
      @quiz.events << @event
      visit course_study_index_path(@course)
    end

    it "should show the event video for the quiz", :js => true do
      page.should have_css("object#ytPlayer")
    end
  end

  describe "when none of the components are due" do

    before(:each) do
      fill_in :input, :with => @quiz.answers.first.text
      click_button "Check answer"
      click_link "Easy"
      visit course_study_path(@course, @quiz)
    end

    it "should display a warning", :js => true do
      page.should have_css("div", :text => "You've already answered this exercise!")
    end

    it "should link to the response when the quiz has already been answered", :js => true do
      page.should have_css("a", :text => "See your last response")
    end
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

  describe "for multiple choice questions" do
    before(:each) do
      @quiz.answer_input = '{"type": "multi", "choices" : ["41","42","43","44"]}'
      @answer.text = "1"
      @answer.save!
      @quiz.save!
      @quiz.reload
      @answer.reload
    end
    
    it "should have multiple choices" do
      visit course_study_index_path(@course)
      page.should have_content("42")
      page.should have_css('input[value="1"]')
    end

    it "should allow user to select an option" do
      @quiz.answers.should == [@answer]
      @answer.text.should == "1"
      visit course_study_index_path(@course)
      choose "42"
      click_button "Check answer"
      page.should_not have_content("incorrect")
    end
  end


  describe "after submitting the response" do

    it "should show the correct answer", :js => true do
      visit course_study_index_path(@course)
      fill_in :input, :with => "41"
      click_button "Check answer"
      page.should have_content("42")
    end

    it "should display help for the problem", :js => true do
      visit course_study_index_path(@course)
      fill_in :input, :with => "41"
      click_button "Check answer"
      page.should have_css("div#help")
    end

    describe "for text input" do

      describe "for correct answers" do

        it "should say the answer was correct", :js => true do 
          visit course_study_index_path(@course)
          fill_in :input, :with => "42"
          click_button "Check answer"
          page.should have_content("correct")
        end

        it "should have a self rating panel", :js => true do
          visit course_study_index_path(@course)
          fill_in :input, :with => @quiz.answers.first.text
          click_button "Check answer"
          page.should have_css("a#rate-hard")
          page.should have_css("a#rate-good")
          page.should have_css("a#rate-easy")
        end

        it "should not allow the user to select a miss", :js => true do
          visit course_study_index_path(@course)
          fill_in :input, :with => @quiz.answers.first.text
          click_button "Check answer"
          page.should_not have_css("a#rate-miss")
        end
      end

      describe "for incorrect answers" do 

        it "should say the answer was incorrect", :js => true do
          visit course_study_index_path(@course)
          fill_in :input, :with => "wrong asnwfaerw"
          click_button "Check answer"
          page.should have_content("incorrect")
        end

        it "should have a next button", :js => true do
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

      it "should not judge the answer", :js => true do
        visit course_study_index_path(@course)
        click_button "Check answer"
        page.should_not have_css("p.flash")
      end

      it "should have a full self rating panel", :js => true do
        visit course_study_index_path(@course)
        click_button "Check answer"
        page.should have_css("a#rate-miss")
        page.should have_css("a#rate-hard")
        page.should have_css("a#rate-good")
        page.should have_css("a#rate-easy")
      end
    end
  end

  describe "rating panel", :js => true do
    it "should not appear for users who have already rated their response" do
      visit course_study_index_path(@course)
      fill_in :input, :with => @quiz.answers.first.text
      click_button "Check answer"
      click_link "Good"

      visit course_study_path(@course, @quiz)
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
