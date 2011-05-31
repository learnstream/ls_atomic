require 'spec_helper'

describe "Login" do
  before(:each) do
    @user = Factory(:user)
  end

  describe "GET /login" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get signin_path
      response.status.should be(200)
    end

    it "should log the user in" do
      visit signin_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_button "Sign in"
      response.should have_selector("h1", :content => "Welcome") 
    end
  end
end
