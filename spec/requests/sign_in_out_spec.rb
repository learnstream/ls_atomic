require 'spec_helper'

describe "Friendly Forwardings" do

  it "should forward to the requested page after signin" do
    course = Factory(:course)
    user = Factory(:user)
    visit courses_path 
    # The test automatically follows the redirect to the signin page.
    fill_in "Email",    :with => user.email
    fill_in "Password", :with => user.password
    click_button "Sign in"
    # The test follows the redirect again, this time to users/edit.
    page.should have_css("a", "text" => course.name) 
  end
end
