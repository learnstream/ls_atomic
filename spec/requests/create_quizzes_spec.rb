require 'spec_helper'

describe "Using the quiz creation interface" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @problem = Factory(:problem, :course => @course)
    @step = Factory(:step, :text => "The first step", :problem => @problem)
    @user = Factory(:admin)
    @quiz = Factory(:quiz, :problem => @problem)
    integration_sign_in(@user)
    visit course_path(@course)
    click_link "Problems"
  end

  it "should allow an authorized user to create quizzes" do
    click_link "Problems"
    click_link "Add quiz"
    page.should have_css("h1", :content => "New quiz")
    page.should have_css("p", :content => @problem.statement)
  end

  it "should create a self-rate quiz" do
    click_link "Problems"
    click_link "Add quiz"
    fill_in "Components", :with => @component.id
    select "The first step", :from => "Steps to show"
    fill_in "Question", :with => "What is the answer?"
    select "Self-rating", :from => "Answer type"
    fill_in "Answer", :with => "42"
    click_button "Submit"
    page.should have_content("Quiz created!")
  end 

  it "should allow an authorized user to edit a quiz" do
    click_link "1"
    fill_in "Question", :with => "Did I change the question?"
    fill_in "Answer", :with => "Yes!"
    click_button "Submit"
    page.should have_content("Quiz edited.")
  end
  
  it "should support free-body-diagram quizzes", :js => true do
    click_link "Problems"
    click_link "Add quiz"
    page.evaluate_script('$("#quiz_component_tokens").val('+@component.id.to_s+')');
    select "The first step", :from => "Steps to show"
    fill_in "Question", :with => "What force is acting on the object"
    select "Free body diagram", :from => "Answer type"
    page.should have_css("#fbd")
  end

  it "should have a back link from the new quiz form" do
    click_link "Problems"
    click_link "Add quiz"
    click_link "Back to problem list"
    page.should have_content(@course.name)
  end
end
