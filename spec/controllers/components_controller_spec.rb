require 'spec_helper'

describe ComponentsController do
  render_views

  describe "access control" do

    it "should deny access to 'create' " do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @component = Factory(:component)
    end

    it "should be successful" do
      get :show, :id => @component
      response.should be_success
    end 

    it "should include the name of the component" do
      get :show, :id => @component
      response.should have_selector("h1", :content => @component.name)
    end  
  end

  describe "List Components" do
    it "should be successful" do
      get :list
      response.should be_success
    end
  end


end
