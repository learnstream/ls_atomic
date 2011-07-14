require 'spec_helper'

describe LessonComponent do
  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)
    @component = Factory(:component, :course => @course)
    @lesson_component = LessonComponent.create!(:lesson_id => @lesson.id, 
                                            :component_id => @component.id)
    @lesson_component.reload
  end

  it "should have a lesson method" do
    @lesson_component.should respond_to(:lesson)
  end

  it "should have the right lesson" do
    @lesson_component.lesson.should == @lesson
  end

  it "should have a component method" do
    @lesson_component.should respond_to(:component)
  end

  it "should have the right component" do
    @lesson_component.component.should == @component
  end

end
