require 'spec_helper'

describe CoursesController do

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      
      before(:each) do
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


  
  describe "GET 'show'" do
    before(:each) do
      @course = Factory(:course)
    end
  
    it "should be successful" do
      get :show, :id => @course
      response.should be_success
    end
  end

end
