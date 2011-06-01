require 'spec_helper'

describe "Studying" do

  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)

    @component = Factory(:component, :course_id => @course)
    @memory = @user.memories.create!(:component_id => @component)
    @memory.due = Time.now.utc
    @memory.save!

    @problem = Factory(:problem, :course_id => @course)
    @step1 = @problem.steps.create(:text => "do this first", :order_number => 1)
    @step2 = @problem.steps.create(:text => "do this next", :order_number => 2) 
    @step2.relate!(@component)
    @step3 = @problem.steps.create(:text => "finally do this", :order_number => 3)
 
    visit signin_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
  end

 
 it "should be accessible from the course page" do
    visit course_path(@course)
    click_link "Study"
    page.should have_content("Studying #{@course.name}")
  end

  pending "should reveal an answer after clicking the show button" do
    visit course_study_index_path(@course)
    click_link "Show"
    page.should have_content("Answer:")
  end
end
