require 'spec_helper'

describe Response do

  before(:each) do
    @course = Factory(:course)
    @user = Factory(:user)
    @quiz = Factory(:text_quiz, :course => @course)
    @component = Factory(:component, :course => @course)
    @quiz.components << @component
    @user.enroll!(@course)
    @response = Factory(:correct_response, :user => @user, :quiz => @quiz)
  end

  it "should have a user attribute" do
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

  it "should be able to rate components for a quiz" do
    lambda do 
      @response.rate_components!(4)
    end.should change(MemoryRating, :count).by(@quiz.components.count)
  end

  it "should be rated when creating an incorrect response" do
    @incorrect_response = Factory(:response, :user => @user, :quiz => @quiz)
    @incorrect_response.reload
    @incorrect_response.has_been_rated.should == true
  end

  it "should not rate components that are not due as a miss" do
    @memory = @user.memories.find_by_component_id(@component)
    @memory.view(4)
    @incorrect_response = Factory(:response, :user => @user, :quiz => @quiz)
    @memory.reload
    @memory.streak.should_not == 0
  end
end
