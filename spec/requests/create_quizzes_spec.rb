require 'spec_helper'

describe "CreateQuizzes" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course_id => @course)
    @problem = Factory(:problem, :course_id => @course)
    @step = Factory(:step, :problem_id => @problem)
    @user = Factory(:admin)
    integration_sign_in(@user)
  end

  it "should create a self-rate quiz" do
    visit course_path(@course)
    click_link "Add quiz"
    fill_in "Components", :with => @component.id
    fill_in "Problem", :with => @problem.id
    check "Step 1"
    fill_in "Question", :with => "What is the answer?"
    select "Self-rate", :from => "Answer type"
    fill_in "Answer", :with => "42"
    click_button "Add quiz"
    page.should have_content("Quiz created!")
  end 

end
