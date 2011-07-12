require 'spec_helper'

describe ComponentsController do
  render_views

  describe "access control for non-signed in users" do

    it "should deny access to 'create' " do
      post :create, :course_id => @course 
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :course_id => @course, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'show'" do
    before(:each) do
      test_sign_in(Factory(:admin))
      @course = Factory(:course)
      @component = Factory(:component, :course => @course)
      @course.components << @component
    end

    it "should be successful" do
      get :show, :course_id => @course, :id => @component
      response.should be_success
    end 

    it "should include the name of the component" do
      get :show, :course_id => @course, :id => @component
      response.should have_selector("h1", :content => @component.name)
    end 

    it "should not have related video headers if no videos have been added" do
      get :show, :course_id => @course, :id => @component
      response.should_not have_selector("h3", :content => "Related Videos:")
    end

    describe "for teachers" do 
      before(:each) do
        @teacher = Factory(:user, :email => Factory.next(:email))
        @teacher.enroll_as_teacher!(@course)
      end

      it "should show edit option" do
        test_sign_in(@teacher)
        get :show, :course_id => @course, :id => @component
        response.should have_selector("a", :content => "Edit", :href => edit_course_component_path(@course))
      end
    end

    describe "for students" do
      before(:each) do
        @student = Factory(:user, :email => Factory.next(:email))
        @student.enroll!(@course)
      end

      it "should not show edit option" do
        test_sign_in(@student)
        get :show, :course_id => @course, :id => @component
        response.should_not have_selector("a", :content => "Edit", :href => edit_component_path(@component))
      end
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @user = test_sign_in(Factory(:admin))
        @course = Factory(:course)
        @attr = { :name => "", :course_id => @course.id}
      end

      it "should not create a k-component" do
        lambda do
          post :create, :course_id => @course, :component => @attr
        end.should_not change(Component, :count)
      end
    end


    describe "for student" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @course = Factory(:course)
        @attr = { :name => "Law of Humpty Dumpty", :description => "When Humpty Dumpty fall, All the Kings Men can't put him back together again!!!!!" }
      end

      it "should not create a k-component" do
        lambda do
          post :create, :course_id => @course, :component => @attr
        end.should_not change(Component, :count)
      end
    end


    describe "for admin" do

      before(:each) do
        @admin = test_sign_in(Factory(:admin))
        @course = Factory(:course)
        @attr = { :name => "Law of Humpty Dumpty", :description => "When Humpty Dumpty fall, All the Kings Men can't put him back together again!!!!!", :course_id => @course.id }
      end

      it "should create a k-component" do
        lambda do
          post :create, :course_id => @course, :component => @attr
        end.should change(Component, :count).by(1)
      end

      it "should redirect to the course components page" do
        post :create, :course_id => @course, :component => @attr
        response.should redirect_to course_components_path(@course)
      end

      it "should flash success" do
        post :create, :course_id => @course, :component => @attr
        flash[:success].should =~ /Knowledge component created/i
      end


      it "should belong to its course" do
        lambda do
          post :create, :course_id => @course, :component => @attr
        end.should change(@course.components, :count).by(1)
      end

      it "should add memory for component to all students in course" do
        @student = Factory(:user)
        @student.enroll!(@course)

        lambda do
          post :create, :course_id => @course, :component => @attr
        end.should change(@student.memories, :count).by(1)
      end
    end

    describe "for teacher" do

      before(:each) do
        @teacher = Factory(:user)
        test_sign_in(@teacher)
        @course = Factory(:course)
        @teacher.enroll_as_teacher!(@course)
        @attr = { :name => "Law of Humpty Dumpty", :description => "When Humpty Dumpty fall, All the Kings Men can't put him back together again!!!!!", :course_id => @course.id }
      end

      it "should create a k-component" do
        lambda do
          post :create, :course_id => @course, :component => @attr
        end.should change(Component, :count).by(1)
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @course = Factory(:course)
      @component = @course.components.create!(:name => "hello", :description => "You are my friend")
      @attr = { :name => @component.name, :description => @component.description }
    end

    describe "generic failure" do
      it "should not update a k-component to a blank name" do
        put :update, :course_id => @course, :id => @component, :component => { :name => "" }
        @component.reload
        @component.name.should == @attr[:name]
      end
    
      it "should not update to the same name as a different component" do
        put :update, :course_id => @course, :id => @component, :component => { :name => "aaa", :course_id => @course.id }
        @component.reload
        @component.name.should == @attr[:name]
      end
    end   


    describe "for students" do

      before(:each) do 
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end
        
      it "should not update the k-component name" do
        put :update, :course_id => @course, :id => @component, :component => { :name => "Calabi-Yau Manifolds"}
        @component.reload
        @component.name.should_not == "Calabi-Yau Manifolds"
      end

      it "should not update the k-component description" do
        put :update, :course_id => @course, :id => @component, :component => {:name=> "Calabi-Yau Manifolds", :description => "Calabi-Yau Manifolds are incomprehensible"}
        @component.reload
        @component.description.should_not == "Calabi-Yau Manifolds are incomprehensible"
      end   
    end  

    describe "for teachers" do

      before(:each) do 
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end
        
      it "should update the k-component name" do
        put :update, :course_id => @course, :id => @component, :component => { :name => "Calabi-Yau Manifolds"}
        @component.reload
        @component.name.should == "Calabi-Yau Manifolds"
      end

      it "should update the k-component description" do
        put :update, :course_id => @course, :id => @component, :component => {:name=> "Calabi-Yau Manifolds", :description => "Calabi-Yau Manifolds are incomprehensible"}
        @component.reload
        @component.description.should == "Calabi-Yau Manifolds are incomprehensible"
      end   
    end  
    
    describe "for admins" do

      before(:each) do 
        @user = Factory(:admin)
        test_sign_in(@user)
      end
        
      it "should update the k-component name" do
        put :update, :course_id => @course, :id => @component, :component => { :name => "Calabi-Yau Manifolds"}
        @component.reload
        @component.name.should == "Calabi-Yau Manifolds"
      end

      it "should update the k-component description" do
        put :update, :course_id => @course, :id => @component, :component => {:name=> "Calabi-Yau Manifolds", :description => "Calabi-Yau Manifolds are incomprehensible"}
        @component.reload
        @component.description.should == "Calabi-Yau Manifolds are incomprehensible"
      end   
    end  
  end

  describe "GET 'edit'" do
    
    before(:each) do
      @course = Factory(:course)
      @component = @course.components.create(:name => "yo", :description => "desc")

      @attr = { :name => @component.name, :description => @component.description }
      @video = Factory(:video, :component_id => @component)
    end

    describe "for authorized users" do

      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should render the edit view" do
        get :edit, :course_id => @course, :id => @component
        response.should be_success
      end

      it "should have a form" do
        get :edit, :course_id => @course, :id => @component
        response.should have_selector("form")
      end

      it "should display related videos" do
        @video = @component.videos.create!(:description => "Awesome example video", :url => "http://www.youtube.com/watch?v=U7mPqycQ0tQ", :start_time => 0, :end_time => 60)
        get :edit, :course_id => @course, :id => @component
        response.should have_selector("div", :content => "Awesome example video")
      end

      it "should have a form to add new videos" do
        get :edit, :course_id => @course, :id => @component
        response.should have_selector("label", :content => "Url")
      end
    end

    describe "for teachers" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll_as_teacher!(@course)
      end

      it "should render the edit view" do
        get :edit, :course_id => @course, :id => @component
        response.should be_success
      end
    end
    

    describe "for students" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not render the edit view" do
        get :edit, :course_id => @course, :id => @component
        response.should_not be_success
      end
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @course = Factory(:course)
    end

    describe "for authorized users" do
      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should be successful" do
        get :new, :course_id => @course 
        response.should be_success
      end
    end

    describe "for students" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @user.enroll!(@course)
      end

      it "should not be successful" do
        get :new, :course_id => @course
        response.should_not be_success
      end
    end
  end
end
