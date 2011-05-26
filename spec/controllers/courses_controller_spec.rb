require 'spec_helper'

describe CoursesController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      @user = Factory(:user, :perm => "creator")
      test_sign_in(@user)
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      
      before(:each) do
        @user = Factory(:user, :perm => "creator")
        test_sign_in(@user)
        @attr = {:name => "", :description => "" }
      end

      it "should not create a course" do
        lambda do
          post :create, :course => @attr
        end.should_not change(Course, :count)
      end

      it "should render the 'new' page" do
        post :create, :course => @attr
        response.should render_template('new')
      end


    end

    describe "success" do

      before(:each) do
        @user = Factory(:user, :perm => "creator")
        test_sign_in(@user)
        @attr = {:name => "Test Course", :description => "This course is really awesome!"}
      end

      it "should create a course" do
        lambda do
          post :create, :course => @attr
        end.should change(Course, :count).by(1)
      end

      it "should render the new course show page" do
        post :create, :course => @attr
        response.should redirect_to(course_path(assigns(:course)))
      end
    end
  end

  describe "authentication" do

    describe "for not signed-in users" do
      before(:each) do
        @not_signed_in = Factory(:user)
        @attr = {:name => "Test Course", :description => "This course is really awesome!"}
      end

      it "should not allow course creation" do
        post :create, :course => @attr
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @signed_in_learner = Factory(:user)
        @signed_in_creator = Factory(:user, :perm => "creator", :email => Factory.next(:email))
        @attr = {:name => "Test Course", :description => "This course is really awesome!"}
      end

      it "should not work for learner" do
        test_sign_in(@signed_in_learner)
        post :create, :course => @attr
        response.should redirect_to @signed_in_learner 
      end
      
      it "should work for creator" do
        test_sign_in(@signed_in_creator)
        post :create, :course => @attr
        response.should redirect_to(course_path(assigns(:course)))
      end
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @course = Factory(:course)
    end
  
    it "should be successful" do
      get :show, :id => @course
      response.should be_success
    end

    it "should display components" do
      get :show, :id => @course
      response.should have_selector("h2", :content => "Components")
    end

    it "should contain component from course" do
      component_in_course = Factory(:component, :course => @course, :name => "Euler's Little Theorem" , :description => "e^pi = -1")
      get :show, :id => @course
      response.should have_selector("a", :content => component_in_course.name)
    end

    it "should have a form" do
      get :show, :id => @course
      response.should have_selector("h2", :content => "Create new component")
    end 
  end
end
