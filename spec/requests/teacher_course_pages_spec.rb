require 'spec_helper'

describe "teacher statistics" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @teacher = Factory(:user, :email => "iamateacher@teacher.com")
    integration_sign_in(@teacher)
    @teacher.enroll_as_teacher!(@course)
    @student = Factory(:user)
    @student.enroll!(@course)
    @memory = @student.memories.create!(@component)
  end

  it "should allow a teacher to access the course global stats page" do
    visit course_path(@course)
    click_link "Course statistics"
    page.should have_css("table",:content => @component.name)
  end

end
