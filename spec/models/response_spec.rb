require 'spec_helper'

describe Response do

  before(:each) do
    @problem = Factory(:problem)
    @user = Factory(:user)
    @quiz = Factory(:text_quiz, :problem_id => @problem)
    @response = Factory(:response, :user_id => @user, :quiz_id => @quiz)
  end

  it "should have a user_id attribute" do
    @response.should respond_to(:user)
  end

  it "should have the correct user" do
    @response.user.should == @user
  end

  it "should have a quiz attribute" do
    @response.should respond_to(:quiz)
  end

  it "should have the correct quiz" do
    @response.quiz.should == @quiz
  end

end
