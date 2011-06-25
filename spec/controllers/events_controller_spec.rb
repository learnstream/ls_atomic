require 'spec_helper'

describe EventsController do

  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @lesson = Factory(:lesson, :course => @course)
    @user.enroll!(@course)
    test_sign_in(@user)
  end

  describe "GET 'index' json" do

    it "should be successful" do
      get :index, :lesson_id => @lesson, :format => :json
      response.should be_success
    end
  end
end
