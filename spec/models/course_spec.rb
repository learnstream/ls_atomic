require 'spec_helper'

describe Course do
  before(:each) do
    @course = Factory(:course)
  end
  
  describe "enrollments" do

    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:admin)
    end

    it "should have an enrollments method" do
      @course.should respond_to(:enrollments)
    end

    it "should have a users method" do
      @course.should respond_to(:users)
    end
    
    it "should have a students method" do
      @course.should respond_to(:students)
    end

    it "should have a teachers method" do
      @course.should respond_to(:teachers)
    end

    it "should have a student enrollments method" do
      @course.should respond_to(:student_enrollments) 
    end

    it "should have the correct enrollments in the enrollments method" do
      @user.enroll!(@course)
      @admin.enroll_as_teacher!(@course)
      @course.student_enrollments.should include(@course.enrollments.find_by_user_id(@user))
      @course.student_enrollments.should_not include(@course.enrollments.find_by_user_id(@admin))
    end

    it "should include enrolled user in the users array" do
      @user.enroll!(@course)
      @course.users.should include(@user)
    end
  end

  describe "lessons" do

    before(:each) do
      @lesson = Factory(:lesson, :course => @course)
    end

    it "should respond to lessons" do
      @course.should respond_to(:lessons)
    end

    it "should have the right lesson" do
      @course.lessons.should include @lesson
    end
    
    it "should be able to return the next lesson for a student" do
      @lesson2 = Factory(:lesson, :name => "Second lesson", :order_number => 999, :course => @course)
      @component1 =  Factory(:component, :name => "A", :course => @course)
      @component2 =  Factory(:component, :name => "B", :course => @course)

      @quiz1 = Factory(:quiz, :course => @course)
      @quiz1.components << @component1
      @event1 = Factory(:event, :lesson => @lesson)
      @quiz1.events << @event1

      @quiz2 = Factory(:quiz, :course => @course)
      @quiz2.components << @component2
      @event2 = Factory(:event, :lesson => @lesson2)
      @quiz2.events << @event2

      @lesson.events << @event1
      @lesson2.events << @event2

      @student = Factory(:user)
      @student.enroll!(@course)

      @student.memories.find_by_component_id(@component1).view(4)

      @course.first_lesson_for(@student).should == @lesson2
    end
  end

  describe "quizzes" do

    before(:each) do
      @quiz = Factory(:quiz, :course => @course)
    end

    it "should respond to quizzes" do
      @course.should respond_to(:quizzes)
    end

    it "should have the right quiz" do
      @course.quizzes.should include @quiz
    end
  end
end
