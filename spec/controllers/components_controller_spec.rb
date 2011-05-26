require 'spec_helper'

describe ComponentsController do
  render_views

  describe "access control" do

    it "should deny access to 'create' " do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @component = Factory(:component)
    end

    it "should be successful" do
      get :show, :id => @component
      response.should be_success
    end 

    it "should include the name of the component" do
      get :show, :id => @component
      response.should have_selector("h1", :content => @component.name)
    end  
  end

  describe "GET 'list'" do
    before(:each) do
      @c1 = Factory(:component, :name => "Newton's first law")
      @c2 = Factory(:component, :name => "Newton's second law")
      @c3 = Factory(:component, :name => "Newton's third law")
    end

    it "should be successful" do
      get :list
      response.should be_success
    end

    it "should list all of the components" do
      get :list
      response.should have_selector("a", :content => @c1.name)
      response.should have_selector("a", :content => @c2.name)
      response.should have_selector("a", :content => @c3.name)
    end

    describe "for logged in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should contain a form" do
        get :list
        response.should have_selector("h2", :content => "Create new component")
        response.should have_selector("form")
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => ""}
      end

      it "should not create a k-component" do
        lambda do
          post :create, :component => @attr
        end.should_not change(Component, :count)
      end

      it "should render list page" do
        post :create, :component => @attr
        response.should render_template('components/list')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Law of Humpty Dumpty", :description => "When Humpty Dumpty fall, All the Kings Men can't put him back together again!!!!!" }
      end

      it "should create a k-component" do
        lambda do
          post :create, :component => @attr
        end.should change(Component, :count).by(1)
      end

      it "should redirect to the list" do
        post :create, :component => @attr
        response.should redirect_to(:db)
      end

      it "should flash sucess" do
        post :create, :component => @attr
        flash[:success].should =~ /Knowledge component created/i
      end

      describe "from a course page" do
        before(:each) do
          @course = Factory(:course)
        end

        it "should belong to that course" do
          lambda do
            post :create, :component => @attr.merge(:course_id => @course.id)
          end.should change(@course.components, :count).by(1)
        end

        it "should redirect to that course" do
          post :create, :component => @attr.merge(:course_id => @course.id)
          response.should redirect_to(course_path(@course.id))
        end
      end 
    end
  end
end
