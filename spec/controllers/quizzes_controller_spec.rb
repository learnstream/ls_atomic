require 'spec_helper'

describe QuizzesController do

  describe "GET 'new'" do

    before(:each) do
      @course = Factory(:course)
      @problem = Factory(:problem, :course_id => @course)
    end

    describe "for authorized users" do
      before(:each) do
        @user = Factory(:admin)
        test_sign_in(@user)
      end

      it "should be successful" do
        get :new, :problem_id => @problem 
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
        get :new, :problem_id => @problem
        response.should_not be_success
      end
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @course = Factory(:course)
      @problem = Factory(:problem, :course_id =>@course)
      @step = Factory(:step, :problem_id => @problem)
      @step2 = Factory(:step, :text => "Another step", :problem_id => @problem)
      @component = Factory(:component, :course_id => @course)
      @component2 = Factory(:component, :name => "Another component", :course_id => @course)
      @attr = {:problem_id => @problem, :component_tokens => "1,2", :steps => ["1", "2"], :question => "What is the color of the sky?", :answer => "blue", :answer_type => "text"}
    end

    describe "generic failure" do

      before(:each) do
        test_sign_in(Factory(:admin))
      end

      it "should not allow quiz to be created with a blank problem" do
        lambda do
          post :create, :quiz => @attr.delete(:problem_id)
        end.should_not change(Quiz, :count)
      end

      it "should not allow quiz to be created with a blank question"  do
        lambda do
          post :create, :quiz => @attr.merge(:question => "")
        end.should_not change(Quiz, :count)
      end

      it "should not allow quiz to be created with a blank answer_type"  do
        lambda do
          post :create, :quiz => @attr.merge(:answer_type => "")
        end.should_not change(Quiz, :count)
      end
    end

    describe "for authorized users" do

      before(:each) do
        test_sign_in(Factory(:admin))
      end

      it "should create a quiz" do
        lambda do
          post :create, :quiz => @attr
        end.should change(Quiz, :count).by(1)
      end

      it "should create a quiz with the correct components" do
        post :create, :quiz => @attr
        quiz = Quiz.first
        quiz.components.should == [ @component, @component2 ]
      end

      it "should create a quiz with the correct steps" do
        post :create, :quiz => @attr
        quiz = Quiz.first
        quiz.steps.should == "1,2"
      end

      it "should create a quiz with the correct answer input" do
        post :create, :quiz => @attr
        quiz = Quiz.first
        @expected = { "type" => "text" }
        parsed_answer_input = JSON.parse(quiz.answer_input)
        parsed_answer_input.should == @expected
      end

      it "should create a quiz with the correct answer output" do
        post :create, :quiz => @attr
        quiz = Quiz.first
        @expected = { "type" => "text" }
        parsed_answer_output = JSON.parse(quiz.answer_output)
        parsed_answer_output.should == @expected
      end

      it "should redirect to the course page" do
        post :create, :quiz => @attr
        response.should redirect_to course_path(@course)
      end
    end

    describe "for students" do
      before(:each) do
        @student = Factory(:user)
        test_sign_in(@student)
        @student.enroll!(@course)
      end

      it "should not create a quiz" do
        lambda do
          post :create, :quiz => @attr
        end.should_not change(Quiz, :count)
      end
    end
  end
end
