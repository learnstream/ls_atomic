require 'spec_helper'

describe "Teacher course page" do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @lesson = Factory(:lesson, :course => @course)
    @quiz = Factory(:quiz, :course => @course)
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
    page.should have_css("table",:text => @lesson.name)
  end

  it "should have a link back to the course page" do
    click_link "Students"
    click_link @course.name
    page.should have_css("a", :text => @course.name)
  end

  it "should have enrolled students on the global stats page" do
    click_link "Students"
    page.should have_css("td", :text => @student.email)
  end

  it "should allow a teacher to see the course components" do
    click_link "Components"
    page.should have_content(@component.name)
  end

  it "should have a link for adding new components" do
    click_link "Components"
    page.should have_css("a", :text => "Add component")
  end

  it "should allow a teacher to see all the quizzes in the course" do
    click_link "Exercises"
    page.should have_css("a", :text => @quiz.question)  
  end

  it "shouldh ave a link for adding new exercises" do
    click_link "Exercises"
    page.should have_css("a", :text => "Add exercise")
  end

  it "should show quizzes with a list of student responses" do
    @response = Factory(:response, :quiz => @quiz, :user => @student)
    click_link "Exercises"
    click_link @quiz.question
    page.should have_css("div", :text => @quiz.question)
    page.should have_css("td", :text => @student.email)
    page.should have_css("td", :text => @response.answer)
  end

  it "should have a link for adding new quizzes" do
    click_link "Exercises"
    page.should have_css("a", :text => "Add exercise")
  end

end
