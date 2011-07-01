require 'spec_helper'

describe Lesson do

  before(:each) do 
    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)
  end

  it "should have a course attribute" do
    @lesson.should respond_to(:course)
  end



  it "should have the right course" do
    @lesson.course.should == @course
  end

  it "should return lessons in the correct order" do 
    @another_lesson = Factory(:lesson, :name => "More first lesson", :course => @course)
    @lesson.order_number = 2
    @lesson.save!

    @course.lessons.first.should == @another_lesson
  end

  it "should have a events attribute" do
    @lesson.should respond_to(:events)
  end

  it "should have the correct events" do
    @note = Factory(:note)
    @event = Factory(:event, :lesson => @lesson)
    @note.events << @event
    @lesson.events.should include(@event)
  end

  describe "statuses" do 
    it "should have a lesson_statuses attribute" do
      @lesson.should respond_to(:lesson_statuses)
    end

    it "should create new lesson statuses for all enrolled students on create" do
      @student = Factory(:user)
      @student.enroll!(@course)

      lambda do
        @lesson2 = Factory(:lesson, :name => "Another lesson", :course => @course)
      end.should change(LessonStatus, :count).by(1)
    end
  end

  describe "components" do

    before(:each) do
      @component = Factory(:component)
      @lesson.components << @component
    end

    it "should have components" do
      @lesson.should respond_to(:components)
    end

    it "should be associated to the correct components" do
      @lesson.components.first.should == @component
    end

  end

end
