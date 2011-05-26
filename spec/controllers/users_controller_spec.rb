require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end  
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  end

  describe "success" do
  
    before(:each) do
      @attr = {:email => "example@test.com", :password => "foobar", :password_confirmation => "foobar" }
    end

    it "should create a user" do
      lambda do
        post :create, :user => @attr
      end.should change(User, :count).by(1)
    end

    it "should render the home page" do
      post :create, :user => @attr
      response.should redirect_to(root_path)
    end
  end


  describe "PUT 'update'" do

    #pending describe "user privileges"

    describe "admin privileges" do
  
      before(:each) do
        @admin = Factory(:user)
        @admin.perm = "admin"
        @admin.save
        @non_admin = Factory(:user, :email => Factory.next(:email))
        @user = Factory(:user, :email => Factory.next(:email))
      end

      it "should not change permissions if user is learner or creator" do
        test_sign_in(@non_admin) 
        put :update, :id => @user, :user => { :perm => "creator" }
        response.should redirect_to(@non_admin)
      end 

      it "should change permissions if the user is an admin" do
        test_sign_in(@admin)
        put :update, :id => @user, :user => { :perm => "creator" }
        @user.reload
        @user.perm.should == "creator"
      end

      it "should re-render the index page after changing permissions" do
        test_sign_in(@admin)
        put :update, :id => @user, :user => { :perm => "creator" }  
        response.should redirect_to users_path
      end 
    end
  end

 describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")

        @users = [@user, second, third]
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content => user.email)
        end
      end
    end
  end 

end

