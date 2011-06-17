require 'spec_helper'

describe "Lessons" do

  before(:each) do
    @user = Factory(:admin)
    @course = Factory(:course)
    integration_sign_in(@user)
  end

  it "should be accessible from the course page" do
    visit course_path(@course)
    click_link "Lessons"
    page.should have_content("Add a new lesson")
  end

  it "should allow user to create a lesson" do
    visit course_path(@course)
    click_link "Lessons"
    click_link "Add a new lesson"
    fill_in "lesson_name", :with => "First lesson"
    click_button "lesson_submit"
    page.should have_css("h1", :text => "First lesson")
  end

  describe "editing" do
    before(:each) do
      @lesson = Factory(:lesson, :course => @course)
    end

    it "should be editable from the lessons index" do 
      visit course_path(@course)
      click_link "Lessons"
      click_link "Edit"
      page.should have_css("h1", :text => @lesson.name)
    end 
  end
end


