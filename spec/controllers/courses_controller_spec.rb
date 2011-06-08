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

      it "should enroll creating user as teacher" do
        post :create, :course => @attr
        @user.taught_courses.index{|course| course.name == @attr[:name]}.should_not          be_nil
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

    describe "for teachers" do

      before(:each) do
        @teacher = Factory(:user, :email => Factory.next(:email))
        @teacher.enroll_as_teacher!(@course)
      end

      it "should be a teacher" do
        @teacher.should be_teacher(@course)
      end

      it "should have a form" do
        test_sign_in(@teacher)
        get :show, :id => @course
        response.should have_selector("a", :content => "Add component")
      end
      it "should have a problem add form" do
        test_sign_in(@teacher)
        get :show, :id => @course
        response.should have_selector("a", :content => "Add problem")
      end

    end 

    describe "for admins" do

      before(:each) do
        @admin = Factory(:admin)
      end

      it "should be a admin" do
        @admin.should be_admin
      end

      it "should have a component add form" do
        test_sign_in(@admin)
        get :show, :id => @course
        response.should have_selector("a", :content => "Add component")
      end

      it "should have a problem add form" do
        test_sign_in(@admin)
        get :show, :id => @course
        response.should have_selector("a", :content => "Add problem")
      end
    end 

    describe "for students" do

      before(:each) do
        @user.enroll!(@course)
      end

      it "should not have a form for adding knowledge components" do
        get :show, :id => @course
        response.should_not have_selector("a", :content => "Add component")
      end

      it "should not have a form for adding problems" do
        get :show, :id => @course
        response.should_not have_selector("a", :content => "Add problem")
      end

    end

  end


  describe "GET 'index'" do
  
    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:admin)
      @creator = Factory(:creator)
      @course1 = Factory(:course)
      @course2 = Factory(:course, :name => Factory.next(:name))
    end

    it "should be successful" do
      test_sign_in(@user)
      get :index
      response.should be_success
    end

    it "should not have create course link for learners" do
      test_sign_in(@user)
      get :index
      response.should_not have_selector("a", :href => new_course_path)
    end

    it "should have create course link for creators" do
      test_sign_in(@creator)
      get :index
      response.should have_selector("a", :href => new_course_path)
    end

    it "should have a create course link for admins" do
      test_sign_in(@admin)
      get :index
      response.should have_selector("a", :href => new_course_path)
    end

    it "should have a button to allow users to enroll" do
      test_sign_in(@user)
      get :index
      response.should have_selector("input", :value => "Enroll")
    end

    it "should show unenroll button if user is already enrolled in course" do
      test_sign_in(@user)
      @user.enroll!(@course1)
      get :index
      response.should have_selector("input", :value => "Unenroll")
    end
  end
       
  describe "enrollment page" do

    describe "when not signed in" do

      it "should protect 'users'" do
        get :users, :id => 1
        response.should redirect_to(signin_path)
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @course = Factory(:course)
        @user.enroll!(@course)
      end

      it "should show enrolled users" do
        get :users, :id => @course
        response.should have_selector("a", :href => user_path(@user), 
                                           :content => @user.email)
      end

      it "should not allow non teachers to set students as teachers" do
        get :users, :id => @course
        response.should_not have_selector( "input", :value => "Make teacher")
      end
    end

    describe "when teacher signed in" do
    
      before(:each) do
        @user = Factory(:user)
        @user2 = Factory(:user, :email => "someotheremail@email.com") 
        test_sign_in(@user)
        @course = Factory(:course)
        @user.enroll_as_teacher!(@course)
        @user2.enroll!(@course)
      end

      it "should allow teachers to set students as teachers" do
        get :users, :id => @course
        response.should have_selector( "input", :value => "Make teacher" )
      end 

      it "should allow teachers to remove themselves as teacher" do
        get :users, :id => @course
        response.should have_selector("input", :value => ("Remove #{@user.email} teacher" ))
      end

      it "should not allow teachers to remove other teachers" do
        @user2.unenroll!(@course) 
        @user2.enroll_as_teacher!(@course)
        get :users, :id => @course
        response.should_not have_selector("input", :value => ("Remove #{@user2.email} teacher" ))
      end
    end
  end

  describe "stats methods" do
    before(:each) do
      @user = Factory(:user)
      @course = Factory(:course)
      @component = Factory(:component, :course_id => Course)
      
      @user.enroll!(@course)
      
      # Create a bunch of components
      (0...3).each { |i|
        Timecop.travel(Time.now + i*2)
        Factory(:component, :course_id => Course, :name => i.to_s)
      }

    end

    it "initially have a progress of 0 for today" do
      get :course_achieved_stats, :id => @course, :format => :json 
  
    end 


  end
end
