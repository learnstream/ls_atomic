require 'spec_helper'

describe VideosController do

  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @problem = Factory(:problem, :course => @course)
    @step = Factory(:step, :problem => @problem)
    @attr = { :url => "http://www.youtube.com/watch?v=U7mPqycQ0tQ", :start_time => 0, :end_time => 25 }
  end

  describe "POST 'create'" do

    describe "for authorized users" do

      before(:each) do
        @admin = Factory(:admin)
        test_sign_in(@admin)
      end

      it "should create a video associated with the right component" do
        post :create, :video => @attr.merge(:component_id => @component.id)
        @component.reload
        @component.videos[0].url.should == @attr[:url]
      end

      it "should create a video associated with the right step" do
        post :create, :video => @attr.merge(:step_id => @step.id)
        @step.reload
        @step.videos[0].url.should == @attr[:url]
      end 
    end


    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should create a video associated with the right component" do
        post :create, :video => @attr.merge(:component_id => @component.id)
        @component.reload
        @component.videos[0].url.should == @attr[:url]
      end

      it "should create a video associated with the right step" do
        post :create, :video => @attr.merge(:step_id => @step.id)
        @step.reload
        @step.videos[0].url.should == @attr[:url]
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

  describe "GET 'edit'" do
    describe "for authorized users" do
      it "should render the edit page" do
        @admin = test_sign_in(Factory(:admin))
        @video = Factory(:video, :component => @component)
        get :edit, :id => @video
        response.should be_success
      end
    end

    describe "for unauthorized users" do
      it "should not render the edit page" do
        @user = Factory(:user)
        test_sign_in(@user)
        @video = Factory(:video, :component => @component)
        @user.enroll!(@video.component.course)
        get :edit, :id => @video
        response.should_not be_success
      end
    end
  end

  describe "DELETE 'destroy'" do
    describe "for authorized users" do
      it "should delete the video" do
        @admin = test_sign_in(Factory(:admin))
        @video = Factory(:video, :component => @component)
        lambda do
          delete :destroy, :id => @video
        end.should change(Video, :count).by(-1)
      end
    end

    describe "for unauthorized users" do
      it "should not delete the video" do
        @user = Factory(:user)
        test_sign_in(@user)
        @video = Factory(:video, :component => @component)
        @user.enroll!(@video.component.course)
        lambda do
          delete :destroy, :id => @video
        end.should_not change(Video, :count)
      end
    end
  end
end
