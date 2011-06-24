require 'spec_helper'

describe "Using the quiz creation interface" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @user = Factory(:admin)
    @quiz = Factory(:quiz, :course => @course)
    integration_sign_in(@user)
    visit course_path(@course)
    click_link "Exercises"
  end

  it "should allow an authorized user to create quizzes" do
    click_link "Add exercise"
    page.should have_css("h1", :content => "New quiz")
  end

  it "should create a self-rate quiz" do
    click_link "Add exercise"
    fill_in "Components", :with => @component.id
    fill_in "Question", :with => "What is the answer?"
    select "Self-rating", :from => "Answer type"
    fill_in "Answer", :with => "42"
    click_button "Submit"
    page.should have_content("Quiz created!")
  end 

  pending "should allow an authorized user to edit a quiz" do
    click_link "1"
    fill_in "Question", :with => "Did I change the question?"
    fill_in "Answer", :with => "Yes!"
    click_button "Submit"
    page.should have_content("Quiz edited.")
  end
  
  it "should support free-body-diagram quizzes", :js => true do
    click_link "Add exercise"
    page.execute_script('$("#quiz_component_tokens").val('+@component.id.to_s+')');
    fill_in "Question", :with => "What force is acting on the object"
    select "Free body diagram", :from => "Answer type"
    page.should have_css("#fbd")
  end
end
