require 'spec_helper'

describe CoursesController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
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
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

end
