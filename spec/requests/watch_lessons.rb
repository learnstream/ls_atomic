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

    integration_sign_in(@user)
    visit course_path(@course)
    click_link @lesson.name
  end
  
  it "should be accessible from the course home page" do
    page.should have_css("h1", :text => @lesson.name)
  end

  it "should have the initial event listed", :js => true do
    page.should have_content(@note.content)
  end

end
