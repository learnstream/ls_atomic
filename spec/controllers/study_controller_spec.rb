require 'spec_helper'

describe StudyController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)

      @user.enroll!(@course)
      
      @component = Factory(:component, :course => @course)
      @memory = @user.memories.find_by_component_id(@component)
      @memory.due = Time.now
      @memory.save!
    end

    describe "when nothing is due" do

      it "should display a friendly message" do
        @memory.due = Time.now + 1.year
        @memory.save!
        get :index, :course_id => @course
        response.should have_selector("div", :content => "Nothing is due")
      end
    end
  end
end
