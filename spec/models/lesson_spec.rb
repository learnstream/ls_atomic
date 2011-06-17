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
end
