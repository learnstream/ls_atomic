require 'spec_helper'

describe MemoriesController do

  before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)

      @component = @course.components.create!(:name => "name", :description => "desc")
      @user.enroll!(@course)
      @memory = @user.memories.find_by_component_id(@component)
  end

  describe "GET 'index'" do

    it "should fail for unenrolled users" do
      @user.unenroll!(@course)
      get :index, :course_id => @course
      response.should_not be_success
    end

    it "should be successful for enrolled users" do
      get :index, :course_id => @course
      response.should be_success
    end

  end

  describe "PUT 'update'" do

    it "should redirect to memories index" do
      put :update, :course_id => @course, :id => @memory
      response.should redirect_to course_memories_path(@course)
    end
  end
end
