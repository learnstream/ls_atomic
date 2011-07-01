require 'spec_helper'

describe "Component page" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @lesson = Factory(:lesson, :course => @course)
    @lesson.components << @component
    
    @student = Factory(:user)
    @teacher = Factory(:user, :email => "teacher@teacher.com")
    @student.enroll!(@course)
    @teacher.enroll_as_teacher!(@course)
    integration_sign_in(@student)

    visit course_component_path(@course, @component)
  end

  it "should have a list of lessons related to the component" do
    page.should have_css("li", :text => @lesson.name)
  end

  it "should take students to the lesson page if link is clicked" do
    click_link @lesson.name
    page.should have_css("h1", :text => @lesson.name)
  end

  it "should take teachers to the edit lesson page if link is clicked" do
    click_link "Sign out"
    integration_sign_in(@teacher)
    visit course_component_path(@course, @component)
    click_link @lesson.name
    page.should have_content("Edit Lesson")
  end
end
