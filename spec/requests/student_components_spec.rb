require 'spec_helper'

describe "Student components list" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @course = Factory(:course)

    @component = @course.components.create!(:name => "name", :description => "desc")

    click_link "courses"
    click_link @course.name
    click_button "Enroll"

    @memory = @user.memories.find_by_component_id(@component)
  end

  it "should allow the user to view components" do 
    click_link "see all components"
    page.should have_css("td", :text => @component.name)
  end

  it "should display unlocked memories first" do
    Timecop.travel(DateTime.now - 10.days) do
      @component2 = @course.components.create!(:name => "name2", :description => "desc2")
    end

    @memory2 = @user.memories.find_by_component_id(@component2)
    @memory.view(4)

    click_link "see all components"
    within("td") do
      page.should have_content(@component.name)
    end
  end

  it "should list the status of each component" do
    click_link "see all components"
    page.should have_css("td", :text => @component.name)
    page.should have_css("td", :text => "Not started")
  end

  it "should allow the student to stop studying components" do
    click_link "see all components"
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

