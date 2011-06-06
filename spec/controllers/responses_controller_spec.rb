require 'spec_helper'

describe ResponsesController do

  describe "POST 'create'" do

    describe "when submitting a valid response" do

      before(:each) do
        @student = Factory(:user)
        test_sign_in(@student)
        @course = Factory(:course)
        @student.enroll!(@course)
        @problem = Factory(:problem, :course_id => @course)
        @quiz = Factory(:quiz, :problem_id => @problem, :answer => "42")
        @attr = { :quiz_id => @quiz, :answer => "42" }
      end

      it "should create a new response object" do
        lambda do
          post :create, :response => @attr
        end.should change(Response, :count).by(1)
      end

      it "should record 'correct' for a correct response" do
        post :create, :response => @attr
        correct_response = Response.first
        correct_response.status.should == "correct"
      end 

      it "should record 'incorrect' for an incorrect response" do
        post :create, :response => @attr.merge({ :answer => "43" })
        incorrect_response = Response.first
        incorrect_response.status.should == "incorrect"
      end

      it "should belong to the signed in user" do
        post :create, :response => @attr
        new_response = Response.first
        new_response.user.should == @student
      end

      it "should redirect to the response" do
        post :create, :response => @attr
        response.should redirect_to response_path(1)
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @student = Factory(:user)
      test_sign_in(@student)
      @course = Factory(:course)
      @student.enroll!(@course)
      @problem = Factory(:problem, :course_id => @course)
      @quiz = Factory(:quiz, :problem_id => @problem, :answer => "42")
      @myresponse = Factory(:response, :quiz_id => @quiz, :user_id => @student)
    end

    it "should be successful" do
      get :show, :id => @myresponse
      response.should be_success
    end
  end
end
