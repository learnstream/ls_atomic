require 'spec_helper'

describe "Problem creation" do

  before(:each) do
    @user = Factory(:admin)
    @course = Factory(:course)
    integration_sign_in(@user)
  end

  it "should allow problems to be added from a course page" do
    visit course_path(@course) 
    click_link "Problems"
    click_link "Add problem"
    fill_in "Name", :with => "How to read Moby Dick"
    fill_in "Statement", :with => "Does the whale exist?"
    click_button "Submit"
    page.should have_css("h1", :content => "Moby Dick")
  end 

  it "should allow the problems to be edited" do
    @problem = Factory(:problem, :course => @course)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    fill_in "Name", :with => "Forgotten problem"
    fill_in "Statement", :with => "What was this problem about?" 
    click_button "Submit"
    page.should have_content("What was this problem about?")
  end

  it "should allow steps to be added" do
    @problem = Factory(:problem, :course => @course)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    fill_in "Text", :with => "A forgotten step for a forgotten problem"
    within("#new_step") { click_button "Submit" }
    fill_in "Order number", :with => "3"
    click_button "Update"
    page.should have_css("li", :content => "A forgotten step for a forgotten problem")
  end

  it "should allow components to be related to steps" do
    @component = Factory(:component, :course => @course)
    @problem = Factory(:problem, :course => @course)
    @step = Factory(:step, :problem => @problem)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    click_link "edit"
    fill_in "Components", :with => @component.id
    click_button "Update"
    click_link "edit"
    @step.should be_related(@component)
  end

  it "should allow steps to be edited" do
    @problem = Factory(:problem, :course => @course)
    @step = Factory(:step, :problem => @problem)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    click_link "edit"
    fill_in "Text", :with => "Forget everything you know"
    click_button "Update"
    page.should have_css("li", :content => "Forget everything you know") 
  end

  it "should allow steps to be rearranged" do
    @problem = Factory(:problem, :course => @course)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    fill_in "Text", :with => "An intermediate step"
    within("#new_step") { click_button "Submit" }
    click_link "Back to problem" 
    fill_in "Text", :with => "The very first step"
    within("#new_step") { click_button "Submit" }
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

  it "should have a back link from the new problem page" do
    @problem = Factory(:problem, :course => @course)
    visit new_course_problem_path(@course)
    click_link "Back to problems"
    page.should have_css("a", :content => @problem)
  end

  it "should link back to problem from problem editing form" do
    @problem = Factory(:problem, :course => @course)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    click_link "Back to problem"
    page.should have_content(@problem.name)
  end

  it "should have a back link to the edit problem page from edit steps" do
    @problem = Factory(:problem, :course => @course)
    @step = Factory(:step, :problem => @problem)
    visit course_problem_path(@course, @problem)
    click_link "Edit"
    click_link "edit"
    click_link "Back to problem edit"
    page.should have_content("Steps")
  end
end
