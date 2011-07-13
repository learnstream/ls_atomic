require 'spec_helper'

describe LessonStatusesController do

  describe "PUT 'update'" do

    before(:each) do
      @course = Factory(:course)
      @lesson = Factory(:lesson, :course => @course)
      @user = Factory(:user)
      test_sign_in(@user)
      @user.enroll!(@course)
      @lesson_status = @user.lesson_statuses.find_by_lesson_id(@lesson)

      @note = Factory(:note)
      @event = Factory(:event)
      @note.events << @event

      @attr = { :event_id => @event.id, :completed => 0 } 
    end

    it "should update the lesson status given valid attributes" do
      put :update, :id => @lesson_status, :lesson_status => @attr
      @lesson_status.reload
      @lesson_status.event.should == @event
    end
  end
end
