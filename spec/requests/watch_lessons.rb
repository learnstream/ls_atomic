require 'spec_helper'

describe "Lessons for the student" do
  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)
    @note = Factory(:note)
    @event = Factory(:event, :lesson => @lesson)
    @note.events << @event
    integration_sign_in(@user)
    visit course_path(@course)
    click_link @lesson.name
  end
  
  it "should be accessible from the course home page" do
    page.should have_css("h1", :text => @lesson.name)
  end

  pending "should have a video player", :js => true do
  
    
    
end
