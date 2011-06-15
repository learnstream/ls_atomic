require 'spec_helper'

describe Event do
  before(:each) do
    @lesson = Factory(:lesson)
    @event = Factory(:event, :lesson => @lesson)
  end

  it "should have a playable attribute" do
    @event.should respond_to(:playable)
  end

  it "should be able to use notes as playable" do
    @note = Factory(:note)
    @note.events << @event
    @note.save
    @event.reload
    @event.playable.should == @note 
  end

  it "should be able to use quizzes as playable" do
    @quiz = Factory(:quiz)
    @quiz.events << @event
    @quiz.save
    @event.reload
    @event.playable.should == @quiz
  end
end
