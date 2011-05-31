require 'spec_helper'

describe MemoriesController do

  describe "GET 'rate'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)

      @component = Factory(:component, :course_id => @course)
      @memory = @user.memories.create!(:component_id => @component)
    end

    it "should fail when given an invalid quality score" do
      get :rate, :id => @memory, :quality => 10
      response.should_not be_success
    end

    it "should redirect to the course study page" do
      get :rate, :id => @memory, :quality => 4 
      response.should redirect_to(course_study_index_path(@course))
    end
  end
end
