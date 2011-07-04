require 'spec_helper'

describe "Enrolling in a course" do

#  before(:all) do
#    Capybara.current_driver = :selenium
#    DatabaseCleaner.strategy = :truncation
#  end
#
#  after(:all) do
#    Capybara.use_default_driver
#    DatabaseCleaner.strategy = :transaction
#  end

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @course = Factory(:course)
    visit courses_path 
  end

  it "should allow you to enroll into a course" do
    click_button "Enroll"
    page.should have_css("h2", :content => "Exercises")
  end
  
  it "should flash a confirmation when you try to unenroll", :js => true do
    @user.enroll!(@course)
    visit current_path

    click_button "Unenroll"
    page.driver.browser.switch_to.alert.accept
    page.should have_css("input", :content => "Enroll")
  end

  
  it "should allow user to choose not to unenroll", :js => true do
    @user.enroll!(@course)
    visit current_path

    click_button "Unenroll"
    page.driver.browser.switch_to.alert.dismiss
    page.should have_css("input", :content => "Unenroll")
  end
end

