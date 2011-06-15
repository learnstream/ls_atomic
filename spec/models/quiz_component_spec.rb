require 'spec_helper'

describe QuizComponent do

  before(:each) do
    @course = Factory(:course)
    @quiz = Factory(:quiz, :course => @course)
    @component = Factory(:component, :course => @course)
    @quiz_component = QuizComponent.create!(:quiz_id => @quiz, 
                                            :component_id => @component)
  end

  it "should have a quiz method" do
    @quiz_component.should respond_to(:quiz)
  end

  it "should have a component method" do
    @quiz_component.should respond_to(:component)
  end

end
