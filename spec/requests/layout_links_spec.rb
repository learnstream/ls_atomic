require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Welcome page at '/'" do
    get '/'
    response.should be_success
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should be_success
  end

  describe "when not signed in" do
    
    it "should have a signin link" do
      visit root_path
      page.should have_css("a", :href => signin_path,
                                :text => "Sign in")
    end

    it "should default to a welcome page" do
      visit root_path
      page.should have_css("div#tagline")
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in "Email",    :with => @user.email
      fill_in "Password", :with => @user.password
      click_button "Sign in"
    end

    it "should have a signout link" do
      visit root_path
      page.should have_css("a", :href => signout_path, 
                                :text => "Sign out")
    end

    it "should redirect to a home page for that user" do
      visit root_path
      page.should have_css("#course-overview")
    end
  end 
end
