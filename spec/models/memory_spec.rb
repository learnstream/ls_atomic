require 'spec_helper'

describe Memory do

  before(:each) do
    @user = Factory(:user)
    @course = Factory(:course)
    @component = @course.components.create!(:name => "My component")
    @user.enroll!(@course)
    @memory = @user.memories.find_by_component_id(@component)
    @default_ease = 2.5
  end

  it "should respond to user" do
    @memory.should respond_to(:user)
  end

  it "should respond to component" do
    @memory.should respond_to(:component)
  end

  it "should create a new instance given valid attributes" do
    @memory.save!
  end

  it "should default to 0 views" do
    @memory.views.should == 0
  end

  it "should default to 0 streak" do
    @memory.streak.should == 0
  end

  it "should default to 2.5 ease" do
    @memory.ease.should == @default_ease
  end

  it "should default to 1.0 interval" do
    @memory.interval.should == 1.0
  end

  it "should default to being due today" do 
    @memory.due.to_date.should == Time.now.utc.to_date 
  end

  it "should default to having never been viewed" do
    @memory.last_viewed.should be_nil
  end

  it "should be able to be viewed" do
    @memory.should respond_to(:view)    
  end

  it "should have a reset method" do
    @memory.should respond_to(:reset)
  end

  it "should create a new memory rating when viewed" do
    lambda do
      @memory.view(4)
    end.should change(MemoryRating, :count).by(1)
  end

  describe "using in_course scope" do

    it "should return memories in that course" do
      @user.memories.in_course(@course.id).should include(@memory)
    end

    it "should not return memories in another course" do
      @another_course = Factory(:course, :name => "Course 2")
      @user.memories.in_course(@another_course.id).should_not include(@memory)
    end
  end
  
  describe "using due_before scope" do
    
    it "should return memories actually due now" do
      @memory.due = Time.now.utc.to_date - 1.day
      @memory.views += 1
      @memory.save
      @user.memories.due_before(Time.now.utc).should include(@memory)
    end

    it "should not return memories not due now" do
      @memory.due = Time.now.utc.to_date + 1.day
      @memory.views += 1
      @memory.save
      @user.memories.due_before(Time.now.utc).should_not include(@memory)
    end
  end

  describe "using course_exercise scope" do

    it "should not include unviewed memories" do
      @user.memories.course_exercise(@course).should_not include(@memory)
    end

    it "should include viewed, due memories from the course" do
      @memory.view(4)
      @memory.due = DateTime.now.utc - 15.minutes
      @memory.save!
      @user.memories.course_exercise(@course).should include(@memory)
    end
  end

  describe "when answered correctly once" do

    before(:each) do 
      @quality = 4
      @memory.view(4)
    end

    it "should have a streak of one" do
      @memory.streak.should == 1
    end

    it "should have one view" do
      @memory.views.should == 1
    end

    it "should have the correct ease" do
      @memory.ease.should == @default_ease - 0.8 + 0.28*@quality - 0.02*@quality**2
    end

    it "should change the interval correctly" do
      @memory.interval.should == 1.0 
    end

    it "should update the due date correctly" do
      @memory.due.to_date.should == Time.now.utc.to_date + 1.day
    end

    it "should have last been viewed today" do
      @memory.last_viewed.to_date.should == Time.now.utc.to_date
    end
  end

  describe "when answered correctly twice" do

    before(:each) do
      @memory.view(4)
      @old_viewed_time = @memory.last_viewed
      @memory.view(4)
    end

    it "should have a streak of two" do
      @memory.streak.should == 2
    end

    it "should have two views" do
      @memory.views.should == 2
    end

    it "should change the interval correctly" do
      @memory.interval.should == 6.0
    end

    it "should have last been viewed today" do
      @memory.last_viewed.to_date.should == Time.now.utc.to_date
    end

    it "should have last been viewed later on the second viewing" do
      @memory.last_viewed.should > @old_viewed_time
    end
  end

  describe "when answered correctly three times" do
    
    before(:each) do
      3.times { @memory.view(4) }
    end

    it "should change the interval correctly" do 
      @memory.interval.round.should == (6.0 * @memory.ease).round
    end
  end

  describe "when answered incorrectly once" do

    before(:each) do
      @memory.view(0)
    end

    it "should update the streak to 0" do
      @memory.streak.should == 0
    end

    it "should have one view" do
      @memory.views.should == 1
    end

    it "should change the interval correctly" do
      @memory.interval.should == 0.0065
    end

    it "should have the correct ease" do 
      @memory.ease.should == @default_ease - 0.8 
    end

    it "should have the correct due date" do
      @memory.due.to_date.should == Time.now.utc.to_date
    end
  end
  
  it "should not allow the ease to decrease below 1.3" do
    10.times do 
      @memory.view(0)
    end
    @memory.ease.should >= 1.3
  end

  it "should be skippable" do
    @memory.skip!
    @memory.should be_viewed
    @memory.should_not be_due
  end

  describe "after being reset" do

    before(:each) do
      @memory.view(4)
      @memory.view(5)
      @memory.view(0)
      @memory.view(4)
      @memory.reset
    end

    it "should have zero views" do
      @memory.views.should == 0
    end

    it "should have zero streak" do
      @memory.streak.should == 0
    end

    it "should have the default ease" do
      @memory.ease.should == @default_ease
    end

    it "should have a null last_viewed" do
      @memory.last_viewed.should be_nil
    end

    it "should be due today" do
      @memory.due.to_date.should == Time.now.utc.to_date
    end
  end

  describe "after being removed" do

    before(:each) do
      @memory.due = DateTime.now.utc - 1.day
      @memory.save!
      @memory.remove!
    end

    it "should not be due" do
      @memory.should_not be_due
    end

    it "should be removed" do
      @memory.should be_removed
    end
  end
end
