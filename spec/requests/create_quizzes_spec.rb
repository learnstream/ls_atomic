require 'spec_helper'

describe "CreateQuizzes" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course_id => @course)
    @problem = Factory(:problem, :course_id => @course)
    @step = Factory(:step, :text => "The first step", :problem_id => @problem)
    @user = Factory(:admin)
    integration_sign_in(@user)
  end

  it "should allow an authorized user to create quizzes" do
    visit course_path(@course)
    click_link "Add quiz"
    page.should have_css("h1", :content => "New quiz")
    page.should have_css("p", :content => @problem.statement)
  end

  it "should create a self-rate quiz" do
    visit course_path(@course)
    click_link "Add quiz"
    fill_in "Components", :with => @component.id
    select "The first step", :from => "Steps to show"
    fill_in "Question", :with => "What is the answer?"
    select "Self-rating", :from => "Answer type"
    fill_in "Answer", :with => "42"
    click_button "Add quiz"
    page.should have_content("Quiz created!")
  end 

end
