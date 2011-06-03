require 'spec_helper'

describe QuizComponent do

  before(:each) do
    @problem = Factory(:problem)
    @quiz = Factory(:quiz, :problem_id => @problem)
    @component = Factory(:component)
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
