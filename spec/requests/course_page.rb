require 'spec_helper'

describe "Course page" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)

    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)

    click_link "courses"
    click_link @course.name
  end
  
  describe "for enrolled users" do

    before(:each) do 
      click_button "Enroll"
    end

    it "should list the lessons" do
      page.should have_css("td", :text => @lesson.name)
    end
  end

  describe "for unenrolled users" do

    it "should have an enrollment button" do
      page.should have_css("input", :value => "Enroll")
    end

    it "should not show the lessons" do
      page.should_not have_css("td", :text => @lesson.name)
    end
  end
end
