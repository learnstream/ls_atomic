require 'spec_helper'

describe EventsController do

  before(:each) do
    @lesson = Factory(:lesson)
  end

  describe "GET 'index' json" do

    it "should be successful" do
      get :index, :lesson_id => @lesson, :format => :json
      response.should be_success
    end
  end
end
