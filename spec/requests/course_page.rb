require 'spec_helper'

describe "Course page" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)

    @course = Factory(:course)

    click_link "courses"
    click_link @course.name
  end

  describe "for unenrolled users" do

    it "should have an enrollment button" do
      page.should have_css("input", :value => "Enroll")
    end

  end
end
