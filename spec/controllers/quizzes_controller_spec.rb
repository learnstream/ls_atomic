require 'spec_helper'

describe QuizzesController do

  before(:each) do
    @course = Factory(:course)
    @quiz = Factory(:quiz, :course => @course)
    @component = Factory(:component, :course => @course)
    @component2 = Factory(:component, :name => "wooooo", :course => @course)
    @quiz.components << @component
    @attr = { :component_tokens => "#{@component.id},#{@component2.id}", :question => "What is the color of the sky?", :answer => "blue", :answer_type => "text"}
  end

  describe "GET 'new'" do

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

  describe "PUT 'update'" do

    before(:each) do 
      @lesson = Factory(:lesson, :course => @course)
      @event = Factory(:event, :lesson => @lesson)
      @quiz.events << @event
      @admin = Factory(:admin)
      test_sign_in(@admin)
      @attr = @attr.merge({ :question => "New question",
                            :existing_event_attributes => { :start_time => 15 } })
    end

    it "should update the attributes given valid attributes" do
      put :update, :id => @quiz, :course_id => @course, :quiz => @attr
      @quiz.reload
      @quiz.question.should == "New question"
    end

    it "should update the attributes for its existing events" do
      put :update, :id => @quiz, :course_id => @course, :quiz => @attr
      @quiz.reload
      @quiz.events.first.start_time.should == 15
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @admin = Factory(:admin)
      test_sign_in(@admin)
    end

    describe "with associated event" do

      before(:each) do
        @lesson = Factory(:lesson)
        @attr = @attr.merge({ :new_event_attributes => { :start_time => 10,
                                                         :end_time   => 20,
                                                         :video_url  => "http://www.youtube.com/watch?v=-O8gbdt5BLc",
                                                         :lesson_id  => @lesson.id,
                                                         :order_number => 1 }})
      end


      it "should be able to create an event for the quiz" do
        lambda do
          post :create, :course_id => @course, :quiz => @attr
        end.should change(Event, :count).by(1)
      end

      it "should create an association with the new event" do
        post :create, :course_id => @course, :quiz => @attr
        new_quiz = Quiz.find_by_question("What is the color of the sky?")
        new_quiz.events.count.should == 1
      end
    end

    it "should not allow quiz to be created with a blank question"  do
      lambda do
        post :create, :course_id => @course, :quiz => @attr.merge(:question => "")
      end.should_not change(Quiz, :count)
    end

    it "should not allow quiz to be created with a blank answer_type"  do
      lambda do
        post :create, :course_id => @course, :quiz => @attr.merge(:answer_type => "")
      end.should_not change(Quiz, :count)
    end


    it "should create a quiz" do
      lambda do
        post :create, :course_id => @course, :quiz => @attr
      end.should change(Quiz, :count).by(1)
    end

    it "should create a quiz with the correct components" do
      post :create, :course_id => @course, :quiz => @attr
      quiz = Quiz.find_by_question(@attr[:question])
      quiz.components.should == [ @component, @component2 ]
    end

    it "should create a quiz with the correct answer input" do
      post :create, :course_id => @course, :quiz => @attr
      quiz = Quiz.find_by_question(@attr[:question])
      @expected = { "type" => "text" }
      parsed_answer_input = JSON.parse(quiz.answer_input)
      parsed_answer_input.should == @expected
    end

    it "should create a quiz with the correct answer output" do
      post :create, :course_id => @course, :quiz => @attr
      quiz = Quiz.find_by_question(@attr[:question])
      @expected = { "type" => "text" }
      parsed_answer_output = JSON.parse(quiz.answer_output)
      parsed_answer_output.should == @expected
    end

    it "should redirect to the course page" do
      post :create, :course_id => @course, :quiz => @attr
      response.should redirect_to course_quizzes_path(@course)
    end

    it "should be able to create a free body diagram quiz" do
      lambda do
        post :create, :course_id => @course, :quiz => @attr.merge(:answer_type => "fbd", 
                                         :answer_input => "{ \"type\" : \"fbd\", \"fb\" : {\"shape\" : \"rect-line\", \"top\" : 80, \"left\" : 80, \"width\" : 162, \"height\" : 100, \"radius\" : 60, \"rotation\" : -15, \"cinterval\" : 30}}",
                                         :answer_output =>"{ \"type\" : \"fbd\", \"fb\" : {\"shape\" : \"rect-line\", \"top\" : 80, \"left\" : 80, \"width\" : 162, \"height\" : 100, \"radius\" : 60, \"rotation\" : -15, \"cinterval\" : 30}, \"forces\" : [{\"origin_index\" : \"8\", \"ox\" : 161, \"oy\" : 130, \"angle\" : -90}]}" )
      end.should change(Quiz, :count).by(1)
    end

    describe "for students" do
      before(:each) do
        @student = Factory(:user)
        test_sign_in(@student)
        @student.enroll!(@course)
      end

      it "should not create a quiz" do
        lambda do
          post :create, :course_id => @course, :quiz => @attr
        end.should_not change(Quiz, :count)
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @student = Factory(:user)
      test_sign_in(@student)
      @student.enroll!(@course)
    end

    it "should be successful" do
      get :show, :id => @quiz
      response.should be_success
    end
  end

  describe "GET 'rate_components'" do
    before(:each) do
      @student = Factory(:user)
      test_sign_in(@student)
      @student.enroll!(@course)
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
