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

      it "should be able to assign another teacher" 

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
  end
end
