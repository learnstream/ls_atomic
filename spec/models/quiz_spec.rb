require 'spec_helper'

describe Quiz do
  
  before(:each) do
    @problem = Factory(:problem)
    @component = Factory(:component)
    @quiz = Factory(:quiz, :problem_id => @problem)
  end

  it "should have a problem method" do
    @quiz.should respond_to(:problem)
  end

  it "should have a quiz components method" do
    @quiz.should respond_to(:quiz_components)
  end

  it "should have a components method" do
    @quiz.should respond_to(:components)
  end

end
