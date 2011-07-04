require 'spec_helper'

describe "Lessons for the student" do
  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)
    @note = Factory(:note)
    @event = Factory(:event, :lesson => @lesson)
    @note.events << @event
    @note2 = Factory(:note, :content => "some other important note stuff")
    @event2 = Factory(:event, :lesson => @lesson, :start_time => 10)
    @note2.events << @event2
    @quiz = Factory(:quiz, :course => @course)
    @event3 = Factory(:event, :lesson => @lesson, :start_time => 20)
    @quiz.events << @event3
    @component = Factory(:component, :course => @course)
    @lesson.components << @component

    integration_sign_in(@user)
    visit course_path(@course)
    click_button "Enroll"
    click_link @lesson.name
  end
  
  it "should be accessible from the course home page" do
    page.should have_css("h1", :text => @lesson.name)
  end

  it "should have the initial event listed", :js => true do
    page.should have_content(@note.content)
  end

  it "should have the initial event listed when the event is a quiz", :js => true do
    @event3.order_number = 0
    @event3.save!
    @event.order_number = 5
    @event.save!
    visit course_lesson_path(@course, @lesson)
    pending("being able to access the fucking quiz page in test mode")
    page.should have_content(@quiz.question)
  end

  it "should update lesson status with the correct event id", :js => true do
    click_link "Next"
    visit course_path(@course)
    click_link @lesson.name
    click_link "Resume at 0:#{@event2.start_time}"
    page.should have_css("div", :text => "some other important note stuff")
  end

  describe "when all of the events have been viewed" do

    before(:each) do
      click_link "Show all"
    end

    it "should mark the lesson as completed when all of the events have been viewed", :js => true do
      visit course_path(@course)
      page.should have_css("td", :text => "Completed")
    end

    it "should mark the lesson as completed and identify the next lesson", :js => true do
      @lesson2 = Factory(:lesson, :name => "Second lesson", :course => @course)
      visit root_path
      page.should have_css("a", :text => @lesson2.name)
    end
  end

  it "should update the last viewed time for the lesson on the course page", :js => true do
    visit course_path(@course)
    Timecop.travel(DateTime.now + 1.days) {
      visit course_path(@course)
      page.should have_css("td", :text => "1 day ago")
    }
  end

  it "should unlock related components" do
    click_link @course.name
    click_link "See all components"
    page.should have_css("td", :text => "Needs review")
  end

  it "should have a link to the course exercises" do
    page.should have_css("a", :text => "Exercises", :href => course_study_index_path(@course))
  end

  it "should have a link to the next lesson" do
    @lesson2 = Factory(:lesson, :order_number => 2, :name => "Lesson TWO")
    visit course_lesson_path(@course, @lesson)
    page.should have_css("a", :text => "Next lesson: " + @lesson2.name, :href => course_lesson_path(@course, @lesson2))
  end
end
