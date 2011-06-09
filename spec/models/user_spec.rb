require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :email => "foo@bar.com", :password => "foobar", :password_confirmation => "foobar" }
    @user = Factory(:user)
  end

  describe "user permissions" do
    
    it "should default to learner upon signup" do
      user_perm = @user.perm 
      user_perm.should ==  "learner"
    end

    it "should require permissions" do
      no_perm_user = User.new(@attr.merge(:perm => ""))
      no_perm_user.should_not be_valid
    end
  end

  describe "enrollments" do

    before(:each) do
      @course = Factory(:course)
    end

    it "should have an enrollments method" do
      @user.should respond_to(:enrollments)
    end

    it "should have a courses method" do
      @user.should respond_to(:courses)
    end

    it "should have a taught_courses method" do
      @user.should respond_to(:taught_courses)
    end

    it "should have a studied_courses method" do
      @user.should respond_to(:studied_courses)
    end

    it "should have an enrolled? method" do
      @user.should respond_to(:enrolled?)
    end

    it "should have an enroll! method" do
      @user.should respond_to(:enroll!)
    end

    it "should enroll in a course" do
      @user.enroll!(@course)
      @user.should be_enrolled(@course)
    end

    it "should include the enrolled course in the courses array" do
      @user.enroll!(@course)
      @user.courses.should include(@course)
    end 

    it "should be a student by default when enrolling in a course" do
      @user.enroll!(@course)
      enrollment = @user.enrollments.find_by_course_id(@course.id)
      enrollment.role.should == "student"
    end

    it "should have an unenroll! method" do
      @user.should respond_to(:unenroll!)
    end

    it "should unenroll from a course" do
      @user.enroll!(@course)
      @user.unenroll!(@course)
      @user.should_not be_enrolled(@course)
    end

    it "should have an enroll_as_teacher! method" do
      @user.should respond_to(:enroll_as_teacher!)
    end

    describe "when enrolled to teach a course" do

      before(:each) do
        @teacher = Factory(:user, :email => Factory.next(:email))
        @teacher.enroll_as_teacher!(@course)
      end 

      it "should have a teacher role" do
        enrollment = @teacher.enrollments.find_by_course_id(@course.id)
        enrollment.role.should == "teacher"
      end

      it "should return that course with taught_courses" do
        @teacher.taught_courses.include?(@course).should == true
      end
    end

    describe "when enrolled to study a course" do
      before(:each) do
        @user.enroll!(@course)
      end

      it "should return that course with studied_courses" do 
        @user.studied_courses.include?(@course).should == true 
      end
    end
  end

  describe "memories" do 
    
    before(:each) do
      @course = Factory(:course)
      @component = Factory(:component, :course_id => @course)
      @memory = @user.remember(@component)
      @comp2 = @course.components.create!(:name => "Comp22", :description => "test")
      @memory2 = @user.remember(@comp2)
      @memory2.due = Time.now.utc + 1000.days
      @memory.due = Time.now.utc - 1000.days
      @memory.save!
      @memory2.save!

      @problem = Factory(:problem, :course_id => @course)
      @quiz = Factory(:quiz, :problem_id => @problem) 
      @quiz.components << @component
    end

    it "should be able to remember a new component" do
      @newcomponent = Factory(:component, :name => "Brand new!")
      @user.remember(@newcomponent)
      @memory = @user.memories.find_by_component_id(@newcomponent).should_not be_nil
    end

    it "should respond to a all_memories method" do
      @user.should respond_to(:all_memories)
    end

    it "should pull up all memories when calling all_memories" do
      @user.all_memories(@component.course).should == [@memory, @memory2]
    end

    it "should respond to a memories_due method" do
      @user.should respond_to(:memories_due)
    end

    it "should pull up the right memories that are due" do
      @memory.due = (Time.now.utc - 1000.days)
      @memory.save!
      @user.memories_due(@component.course).should == [@memory]
    end 

    it "should pull up all memories with a quiz when calling all_memories_with_quiz" do
      @user.all_memories_with_quiz(@course).should == [@memory]
    end

    it "should have a memories_due_with_quiz method" do
      @user.should respond_to(:memories_due_with_quiz)
    end

    it "should only pull up memories due with a quiz" do
      @memory.due = (Time.now.utc - 1000.days)
      @memory2.due = (Time.now.utc - 3000.days)
      @memory.save!
      @memory2.save!
      @user.memories_due_with_quiz(@component.course).should == [@memory]
    end 

  end

  describe "user statistics" do

    before(:each) do
      @course = Factory(:course)
      @component = Factory(:component, :course_id => @course.id)
      @memory = @user.remember(@component)
    end

    it "should respond to a stats method" do
      @user.should respond_to(:stats)
    end

    it "should pull up a stats array" do
      @memory.view(3)
      @user.stats(@course, Time.now.utc - 1.day, Time.now.utc).should == [0,1,0,0]
    end
  end 
end
