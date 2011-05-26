require 'spec_helper'
describe "LayoutLinks" do

  it "should have a Home page at '/'" do
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
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end
  end 

end

