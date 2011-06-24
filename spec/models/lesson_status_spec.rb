require 'spec_helper'

describe LessonStatus do
  before(:each) do 
    @course = Factory(:course)
    @student = Factory(:user)
    @student.enroll!(@course)

    @lesson = Factory(:lesson, :course => @course)
  end

  it "should be created by a lesson" do
    LessonStatus.count.should == 1
  end

  it "should be created by an enrollment" do 
    @student2 = Factory(:user, :email => Factory.next(:email))
    LessonStatus.count.should == 1
    @student2.id.should_not == @student.id
    @student2.lesson_statuses.count.should == 0
    puts "created student" 
    
    @student2.enroll!(@course)
    LessonStatus.count.should == 2
  end

  it "should not be created by a teacher enrollment" do
    @teacher = Factory(:user, :email => Factory.next(:email))
    @teacher.enroll_as_teacher!(@course)
    LessonStatus.count.should == 1
  end

  it "should have a lesson attribute"
end
