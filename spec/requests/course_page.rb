require 'spec_helper'

describe "Course page" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)

    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)

    @component = Factory(:component, :course => @course)

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

    it "should link to a list of components" do
      page.should have_css("a", :text => "See all components")
    end

    it "should list the status of each component on the component page" do
      click_link "See all components"
      page.should have_css("td", :text => @component.name)
      page.should have_css("td", :text => "Not started")
    end

    it "should allow the student to stop studying components" do
      click_link "See all components"
      click_button "Stop studying"
      page.should have_css("td", :text => "Not being studied")
    end

    it "should update the status when the component is viewed" do
      @memory = @user.memories.find_by_component_id(@component)
      @memory.view(4)
      click_link "all components"
      page.should have_css("td", :text => @component.name)
      page.should have_css("td", :text => "Weak")
      page.should have_css("td", :text => "1 time")
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
