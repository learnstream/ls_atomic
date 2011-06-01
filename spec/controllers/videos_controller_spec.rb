require 'spec_helper'

describe VideosController do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course_id => @course.id)
    @attr = { :url => "http://www.youtube.com/watch?v=U7mPqycQ0tQ", :start_time => 0, :end_time => 25 }
  end

  describe "POST 'create'" do

    describe "for authorized users" do

      before(:each) do
        @admin = Factory(:admin)
        test_sign_in(@admin)
      end

      it "should create a video" do
        lambda do
          post :create, :video => @attr.merge(:component_id => @component.id) 
        end.should change(Video, :count).by(1)
      end

      it "should create a video associated with the right component" do
        post :create, :video => @attr.merge(:component_id => @component.id)
        @component.reload
        @component.videos[0].url.should == @attr[:url]
      end
    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should create a video" do
        lambda do
          post :create, :video => @attr.merge(:component_id => @component.id) 
        end.should change(Video, :count).by(1)
      end

      it "should create a video associated with the right component" do
        post :create, :video => @attr.merge(:component_id => @component.id)
        @component.reload
        @component.videos[0].url.should == @attr[:url]
      end
    end

    describe "for students" do
      it "should not create a video" do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
        lambda do
          post :create, :video => @attr.merge(:component_id => @component.id) 
        end.should_not change(Video, :count)
      end
    end
  end
end
