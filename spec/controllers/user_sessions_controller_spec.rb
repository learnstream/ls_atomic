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

    describe "with valid email and password" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :user_session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the home page" do
        post :create, :user_session => @attr
        response.should redirect_to(root_path)
      end
    end
  end
end
