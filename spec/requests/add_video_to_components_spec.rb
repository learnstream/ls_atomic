require 'spec_helper'

describe "AddVideoToComponents" do

  before(:each) do
    @course = Factory(:course)
    @teacher = Factory(:user)
    @teacher.enroll_as_teacher!(@course)
    @component = Factory(:component, :course => @course)
    integration_sign_in(@teacher)
  end

  it "should add a video to a component" do
    visit edit_component_path(@component)
    within "#new_video" do
      fill_in "Url", :with => "http://www.youtube.com/watch?v=nIBfNsPDw1I&feature=feedrec_grec_index" 
      fill_in "Start time", :with => 0
      fill_in "End time", :with => 60
      fill_in "Name", :with => "Spaghetti"
      fill_in "Description", :with => "Om nom nom"
      click_button "Add video" 
    end
    page.should have_content("Video created!")
  end 
end
