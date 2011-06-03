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
      @component = Factory(:component)
    end

    it "should be able to remember a new component" do
      @user.remember(@component)
      @memory = @user.memories.find_by_component_id(@component).should_not be_nil
    end

    it "should respond to a all_memories method" do
      @user.should respond_to(:all_memories)
    end

    it "should pull up all memories when calling all_memories" do
      @memory = @user.remember(@component)
      @course = @component.course
      @comp2 = @course.components.create!(:name => "Comp22", :description => "test")
      @memory2 = @user.remember(@comp2)
      @memory2.due = Time.now.utc + 1000
      @memory.due = Time.now.utc - 1000
      @memory.save!
      @memory2.save!
      @user.all_memories(@component.course).should == [@memory, @memory2]
    end

    it "should respond to a memories_due method" do
      @user.should respond_to(:memories_due)
    end

    it "should pull up the right memories that are due" do
      @memory = @user.remember(@component)
      @memory.due = (Time.now.utc - 1000)
      @user.memories_due(@component.course)[0] == @memory
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
