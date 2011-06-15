require 'spec_helper'

describe QuizzesController do

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

  describe "POST 'create'" do
    
    before(:each) do
      @course = Factory(:course)
      @component = Factory(:component, :course => @course)
      @component2 = Factory(:component, :name => "wooooo", :course => @course)
      @attr = { :component_tokens => "#{@component.id},#{@component2.id}", :question => "What is the color of the sky?", :answer => "blue", :answer_type => "text"}
    end

    describe "generic failure" do

      before(:each) do
        test_sign_in(Factory(:admin))
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
        @admin = Factory(:admin)
        test_sign_in(@admin)
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
        response.should redirect_to course_quizzes_path(@course)
      end

      it "should be able to create a free body diagram quiz" do
        lambda do
          post :create, :quiz => @attr.merge(:answer_type => "fbd", 
                                           :answer_input => "{ \"type\" : \"fbd\", \"fb\" : {\"shape\" : \"rect-line\", \"top\" : 80, \"left\" : 80, \"width\" : 162, \"height\" : 100, \"radius\" : 60, \"rotation\" : -15, \"cinterval\" : 30}}",
                                           :answer_output =>"{ \"type\" : \"fbd\", \"fb\" : {\"shape\" : \"rect-line\", \"top\" : 80, \"left\" : 80, \"width\" : 162, \"height\" : 100, \"radius\" : 60, \"rotation\" : -15, \"cinterval\" : 30}, \"forces\" : [{\"origin_index\" : \"8\", \"ox\" : 161, \"oy\" : 130, \"angle\" : -90}]}" )
        end.should change(Quiz, :count).by(1)
      end

      it "should be able to create a quiz with no steps" do
        lambda do
          post :create, :quiz => @attr.merge(:steps => [])
        end.should change(Quiz, :count).by(1)
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

  describe "GET 'show'" do

    before(:each) do
      @course = Factory(:course)
      @student = Factory(:user)
      test_sign_in(@student)
      @student.enroll!(@course)
      @quiz = Factory(:quiz, :course => @course)
    end

    it "should be successful" do
      get :show, :id => @quiz
      response.should be_success
    end
  end

  describe "GET 'rate_components'" do
    before(:each) do
      @course = Factory(:course)
      @student = Factory(:user)
      test_sign_in(@student)
      @student.enroll!(@course)
      @quiz = Factory(:quiz, :course => @course)
      @component = Factory(:component, :course => @course)
      @quiz.components << @component
      @memory = @student.memories.find_by_component_id(@component)
    end

    it "should rate each component" do
      lambda do
        get :rate_components, :id => @quiz, :quality => 3
      end.should change(MemoryRating, :count).by(1)
    end

    it "should give the correct rating to the components" do
      get :rate_components, :id => @quiz, :quality => 3
      @student.memories.last.memory_ratings.last.quality.should == 3
    end

    it "should not allow student to rate components that have been rated recently" do
      get :rate_components, :id => @quiz, :quality => 3
      get :rate_components, :id => @quiz, :quality => 4
      @student.memories.last.memory_ratings.last.quality.should == 3
    end

    it "should allow student to rate components again once they are due" do
      get :rate_components, :id => @quiz, :quality => 3
      @memory = @student.memories.last
      @memory.due = Date.today.prev_day.to_datetime
      @memory.save
      get :rate_components, :id => @quiz, :quality => 4
      @memory.memory_ratings.last.quality.should == 4
    end
  end
end
