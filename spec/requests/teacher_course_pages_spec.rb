require 'spec_helper'

describe "Teacher course page" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @problem = Factory(:problem, :course => @course)
    @teacher = Factory(:user, :email => "iamateacher@teacher.com")
    integration_sign_in(@teacher)
    @teacher.enroll_as_teacher!(@course)
    @student = Factory(:user)
    @student.enroll!(@course)
    @memory = @student.memories.create!(@component)
    visit course_path(@course)
  end

  it "should allow a teacher to access the course global stats page" do
    click_link "Students"
    page.should have_css("table",:content => @component.name)
  end

  it "should have a link back to the course page" do
    click_link "Students"
    click_link @course.name
    page.should have_css("h1", :content => @course.name)
  end

  it "should have enrolled students on the global stats page" do
    click_link "Students"
    page.should have_css("td", :content => @student.email)
  end

  it "should allow a teacher to see all the problems in the course" do
    click_link "Problems"
    page.should have_content(@problem.name)
  end

  it "should allow a teacher to see the course components" do
    click_link "Components"
    page.should have_content(@component.name)
  end

  it "should have a link for adding new components" do
    click_link "Components"
    page.should have_css("a", :content => "Add component")
  end

  it "should have a link for adding new problems" do
    click_link "Problems"
    page.should have_css("a", :content => "Add problem")
  end

end
