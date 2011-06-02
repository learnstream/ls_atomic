require 'spec_helper'

describe "Problem creation" do

  before(:each) do
    @user = Factory(:admin)
    @course = Factory(:course)
    integration_sign_in(@user)
  end

  it "should allow problems to be added from a course page" do
    visit course_path(@course) 
    click_link "Add problem"
    fill_in "Name", :with => "How to read Moby Dick"
    fill_in "Statement", :with => "Does the whale exist?"
    click_button "Submit"
    page.should have_content("Moby Dick")
  end 

  it "should allow the problems to be edited" do
    @problem = Factory(:problem)
    visit problem_path(@problem)
    click_link "Edit"
    fill_in "Name", :with => "Forgotten problem"
    fill_in "Statement", :with => "What was this problem about?" 
    click_button "Update"
    page.should have_content("What was this problem about?")
  end

  it "should allow steps to be added" do
    @problem = Factory(:problem)
    visit problem_path(@problem)
    click_link "Edit"
    fill_in "Text", :with => "A forgotten step for a forgotten problem"
    click_button "Submit"
    fill_in "Order number", :with => "3"
    click_button "Update"
    page.should have_css("li", :content => "A forgotten step for a forgotten problem")
  end

  it "should allow components to be related to steps" do
    @component = Factory(:component, :course_id => @course)
    @problem = Factory(:problem, :course_id => @course)
    @step = Factory(:step, :problem_id => @problem)
    visit problem_path(@problem)
    click_link "Edit"
    click_link "edit"
    fill_in "Components", :with => @component.id
    click_button "Update"
    click_link "edit"
    @step.should be_related(@component)
  end

  it "should allow steps to be edited" do
    @step = Factory(:step)
    visit problem_path(@step.problem)
    click_link "Edit"
    click_link "edit"
    fill_in "Text", :with => "Forget everything you know"
    click_button "Update"
    page.should have_css("li", :content => "Forget everything you know") 
  end

  it "should allow steps to be rearranged" do
    @problem = Factory(:problem)
    visit problem_path(@problem)
    click_link "Edit"
    fill_in "Text", :with => "An intermediate step"
    click_button "Submit"
    click_link "Back to problem" 
    fill_in "Text", :with => "The very first step"
    click_button "Submit"
    click_link "Back to problem"

    within("ol > li") { click_link("edit") }
    fill_in "Order number", :with => "3"
    click_button "Update"
    within("ol > li") { click_link("edit") }
    fill_in "Order number", :with => "1" 
    click_button "Update"
    within(:css, "ol > li + li") { click_link("edit") }
    fill_in "Order number", :with => "2"
    click_button "Update"

    page.should have_css("ol > li", :content => "The very first step")
  end
end
