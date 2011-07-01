require 'spec_helper'

describe LessonStatus do
  before(:each) do 
    @course = Factory(:course)
    @student = Factory(:user)
    @student.enroll!(@course)

    @lesson = Factory(:lesson, :course => @course)
  end

  it "should be created for each student by a lesson" do
    LessonStatus.count.should == 1
  end

  it "should be created by an enrollment" do 
    @student2 = Factory(:user, :email => Factory.next(:email))
    LessonStatus.count.should == 1
    @student2.id.should_not == @student.id
    @student2.lesson_statuses.count.should == 0
    
    @student2.enroll!(@course)
    LessonStatus.count.should == 2
  end

  it "should not be created by a teacher enrollment" do
    @teacher = Factory(:user, :email => Factory.next(:email))
    @teacher.enroll_as_teacher!(@course)
    LessonStatus.count.should == 1
  end

  it "should be destroyed when the student unenrolls" do
    @student.unenroll!(@course)
    LessonStatus.count.should == 0
  end

  it "should have a lesson attribute" do
    @lesson_status = @student.lesson_statuses.first
    @lesson_status.should respond_to(:lesson)
  end
end
