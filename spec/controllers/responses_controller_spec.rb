require 'spec_helper'

describe ResponsesController do

  describe "POST 'create'" do

    describe "when submitting a valid response" do

      before(:each) do
        @student = Factory(:user)
        test_sign_in(@student)
        @course = Factory(:course)
        @student.enroll!(@course)
        @component = Factory(:component, :course => @course)

        @quiz = Factory(:quiz, :course => @course)
        @quiz.components << @component
        @attr = { :quiz => @quiz, :answer => @quiz.answer }
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

      it "should record a memory miss for an incorrect response" do
        post :create, :response => @attr.merge({ :answer => "43" })
        incorrect_response = Response.first
        component = incorrect_response.quiz.components.first
        memory = incorrect_response.user.memories.find_by_component_id(component)
        memory.memory_ratings.last.quality.should == 0
      end

      it "should belong to the signed in user" do
        post :create, :response => @attr
        new_response = Response.first
        new_response.user.should == @student
      end

      it "should redirect to the response" do
        post :create, :response => @attr
        response.should redirect_to Response.first
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @student = Factory(:user)
      test_sign_in(@student)
      @course = Factory(:course)
      @student.enroll!(@course)
      @quiz = Factory(:quiz, :course => @course, :answer => "42")
      @myresponse = Factory(:response, :quiz => @quiz, :user => @student)
    end

    it "should rate the quiz components with the given quality" do
      lambda do
        put :update, :id => @myresponse, :quality => "4"
      end.should change(MemoryRating, :count).by(@quiz.components.count)
    end

    it "should change the response to have been rated" do
      put :update, :id => @myresponse, :quality => "4"
      @myresponse.reload
      @myresponse.has_been_rated.should == true
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @student = Factory(:user)
      test_sign_in(@student)
      @course = Factory(:course)
      @student.enroll!(@course)
      @quiz = Factory(:quiz, :course => @course, :answer => "42")
      @myresponse = Factory(:response, :quiz => @quiz, :user => @student)
    end

    it "should be successful" do
      get :show, :id => @myresponse
      response.should be_success
    end
  end
end
