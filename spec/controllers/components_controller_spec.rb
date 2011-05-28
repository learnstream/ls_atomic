require 'spec_helper'

describe ComponentsController do
  render_views

  describe "access control for non-signed in users" do

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
      @course = Factory(:course)
      @component = Factory(:component, :course => @course)
      @course.components << @component
    end

    it "should be successful" do
      get :show, :id => @component
      response.should be_success
    end 

    it "should include the name of the component" do
      get :show, :id => @component
      response.should have_selector("h1", :content => @component.name)
    end  

    describe "for teachers" do 
      before(:each) do
        @teacher = Factory(:user, :email => Factory.next(:email))
        @teacher.enroll_as_teacher!(@course)
      end

      it "should show edit option" do
        test_sign_in(@teacher)
        get :show, :id => @component
        response.should have_selector("a", :content => "Edit", :href => edit_component_path)
      end
    end

    describe "for students" do
      before(:each) do
        @student = Factory(:user, :email => Factory.next(:email))
        @student.enroll!(@course)
      end

      it "should not show edit option" do
        test_sign_in(@student)
        get :show, :id => @component
        response.should_not have_selector("a", :content => "Edit", :href => edit_component_path(@component))
      end
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

    describe "failure" do

      before(:each) do
        @user = test_sign_in(Factory(:admin))
        @course = Factory(:course)
        @attr = { :name => "", :course_id => @course.id}
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


    describe "for student" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @course = Factory(:course)
        @attr = { :name => "Law of Humpty Dumpty", :description => "When Humpty Dumpty fall, All the Kings Men can't put him back together again!!!!!", :course_id => @course.id }
      end

      it "should not create a k-component" do
        lambda do
          post :create, :component => @attr
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
          post :create, :component => @attr
        end.should change(Component, :count).by(1)
      end

      it "should redirect to the course" do
        post :create, :component => @attr
        response.should redirect_to(@course)
      end

      it "should flash sucess" do
        post :create, :component => @attr
        flash[:success].should =~ /Knowledge component created/i
      end

      describe "from a course page" do

        it "should belong to that course" do
          lambda do
            post :create, :component => @attr
          end.should change(@course.components, :count).by(1)
        end

        it "should redirect to that course" do
          post :create, :component => @attr
          response.should redirect_to(course_path(@course.id))
        end
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
          post :create, :component => @attr
        end.should change(Component, :count).by(1)
      end

      it "should redirect to the course" do
        post :create, :component => @attr
        response.should redirect_to(@course)
      end

      it "should flash sucess" do
        post :create, :component => @attr
        flash[:success].should =~ /Knowledge component created/i
      end

      describe "from a course page" do
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

  describe "PUT 'update'" do

    before(:each) do
      @user = test_sign_in(Factory(:admin))
      @course = Factory(:course)
      @component = Factory(:component)
      @attr = { :name => @component.name, :description => @component.description }
      post :create, :component => @attr.merge(:course_id => @course.id) 
    end

    describe "failure" do
      it "should not update a k-component to a blank name" do
        put :update, :id => @component, :component => { :name => "" }
        @component.reload
        @component.name.should == @attr[:name]
      end
    
      it "should not update to the same name as a different component" do
        post :create, :component => { :name => "aaa", :description => "asdfasdf", :course_id => @course.id }
        put :update, :id => @component, :component => { :name => "aaa", :course_id => @course.id }
        @component.reload
        @component.name.should == @attr[:name]
      end
    end   

    describe "success" do
      it "should update the k-component name" do
        put :update, :id => @component, :component => { :name => "Calabi-Yau Manifolds"}
        @component.reload
        @component.name.should == "Calabi-Yau Manifolds"
      end

      it "should update the k-component description" do
        put :update, :id => @component, :component => {:name=> "Calabi-Yau Manifolds", :description => "Calabi-Yau Manifolds are incomprehensible"}
        @component.reload
        @component.description.should == "Calabi-Yau Manifolds are incomprehensible"
      end   
    end  
  end

  describe "GET 'edit'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @course = Factory(:course)
      @component = Factory(:component)
      @attr = { :name => @component.name, :description => @component.description }
      post :create, :component => @attr.merge(:course_id => @course.id)
    end

    it "should render the edit view" do
      get :edit, :id => @component
      response.should be_success
    end

    it "should have a form" do
      get :edit, :id => @component
      response.should have_selector("form")
    end
  end
end
