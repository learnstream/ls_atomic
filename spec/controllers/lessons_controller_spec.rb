require 'spec_helper'

describe LessonsController do
  render_views

  before(:each) do 
    @teacher = Factory(:user)
    @course = Factory(:course)
    @teacher.enroll_as_teacher!(@course)
    test_sign_in(@teacher)
  end

  describe "permissions" do 
    before(:each) do
      @student = Factory(:user, :email => Factory.next(:email))
      @student.enroll!(@course)
      test_sign_in(@student)
    end
    
    it "should not allow a student to access the controller" do
      get 'new', :course_id => @course
      response.should_not be_success
    end
  end


  describe "GET 'index'" do
    it "should be successful" do
      get :index, :course_id => @course
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', :course_id => @course
      response.should be_success
    end
  end

  describe "GET 'edit'" do

    before(:each) do 
      @lesson = Factory(:lesson, :course => @course)
    end 

    it "should be successful" do
      get 'edit', :course_id => @course, :id => @lesson
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attr = { :order_number => 1, :name => "Lesson 1" }
    end

    it "should create a new lesson" do
      lambda do
        post :create, :course_id => @course, :lesson => @attr
      end.should change(Lesson, :count).by(1)
    end

    it "should not create a lesson with a duplicate name in the same course" do
      @lesson = Factory(:lesson, :course => @course)
      lambda do
        post :create, :course_id => @course, :lesson => @attr.merge(:name => @lesson.name)
      end.should_not change(Lesson, :count)
    end
  end

  describe "PUT 'update'" do
    
    before(:each) do
      @lesson = Factory(:lesson, :course => @course)
      @attr = { :order_number => @lesson.order_number, :name => @lesson.name }
    end

    it "should update the attributes for a lesson" do
      put :update, :course_id => @course, :id => @lesson, :lesson => @attr.merge(:name => "Another name", 
                                                                 :order_number => 2)
      @lesson.reload
      @lesson.name.should == "Another name"
      @lesson.order_number.should == 2
    end

    it "should not allow a lesson to change to a duplicate name" do
      @another_lesson = Factory(:lesson, :name => "Another name", :course => @course)
      put :update, :course_id => @course, :id => @lesson, :lesson => @attr.merge(:name => "Another name")
      @lesson.reload
      @lesson.name.should_not == "Another name"
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @lesson = Factory(:lesson, :course => @course)
    end

    it "should delete a lesson" do
      lambda do
        delete :destroy, :course_id => @course, :id => @lesson
      end.should change(Lesson, :count).by(-1)
    end
  end
end
