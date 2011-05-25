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

  describe "GET 'list'" do
    before(:each) do
      @c1 = Factory(:component, :name => "Newton's first law")
      @c2 = Factory(:component, :name => "Newton's second law")
      @c3 = Factory(:component, :name => "Newton's third law")
    end

    it "should be successful" do
      get :list
      response.should be_success
    end

    it "should list all of the components" do
      get :list
      response.should have_selector("a", :content => @c1.name)
      response.should have_selector("a", :content => @c2.name)
      response.should have_selector("a", :content => @c3.name)
    end
  end
end
