require 'spec_helper'

describe UserSessionsController do
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invaliddd" }
      end

      it "should re-render the new page" do
        post :create, :user_session => @attr
      end
    end

    describe "with valid email and password"
  end
end
