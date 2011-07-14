require 'spec_helper'

describe Quiz do
  
  before(:each) do
    @course = Factory(:course)
    @component = Factory(:component, :course => @course)
    @quiz = Factory(:quiz, :course => @course)
    @quiz.components << @component
    @student = Factory(:user)
    @student.enroll!(@course)
  end

  it "should have a quiz components method" do
    @quiz.should respond_to(:quiz_components)
  end

  it "should have a components method" do
    @quiz.should respond_to(:components)
  end

  it "should have the right components" do
    @quiz.components.should include(@component)
  end

  it "should allow components to be set through :component_tokens" do
    @c1 = Factory(:component, :course => @course, :name => "name1") 
    @c2 = Factory(:component, :course => @course, :name => "name2") 
    @c3 = Factory(:component, :course => @course, :name => "name3") 
    @quiz.component_tokens = [@c1.id, @c2.id, @c3.id].join(",") 
    @quiz.save!
    @quiz.components.should == [@c1, @c2, @c3]
  end

  it "should have a responses method" do
    @quiz.should respond_to(:responses)
  end

  it "should have a course method" do
    @quiz.should respond_to(:course)
  end

  it "should have the right course" do
    @quiz.course.should == @course
  end

  it "should be skippable, which skips each component" do
    @quiz.skipped_by(@student)
    
    @student.memories.find_by_component_id(@component).should_not be_due
    @student.memories.find_by_component_id(@component).should be_viewed
  end

  describe "due scope" do

    before(:each) do
      @component2 = Factory(:component, :name => "comp2", :course => @course)
      @quiz.components << @component2
      @memory = @student.memories.find_by_component_id(@component)
      @memory2 = @student.memories.find_by_component_id(@component2)
      Timecop.travel(DateTime.now - 10.days) do
        @memory.view(4)
        @memory2.view(4)
      end
      @memory.view(4)
    end

    it "should return the quiz when one of the components is due" do
      Quiz.due(@course.id, @student.id).should include(@quiz)
    end

    it "should not return the quiz when none of the components are due" do
      @memory2.view(4)
      Quiz.due(@course.id, @student.id).should_not include(@quiz)
    end
  end

  describe "locked/unlocked scopes" do
  
    before(:each) do
      @component2 = Factory(:component, :name => "comp2", :course => @course)
      @quiz.components << @component2
      @memory = @student.memories.find_by_component_id(@component)
      @memory2 = @student.memories.find_by_component_id(@component2)
      @memory2.view(4)
    end

    describe "when the quiz has a locked memory" do

      it "should return the quiz with the locked scope" do
        Quiz.locked(@course.id, @student.id).should include(@quiz)
      end
      
      it "should not return the quiz with the unlocked scope" do
        Quiz.unlocked(@course.id, @student.id).should_not include(@quiz)
      end
    end

    describe "when the quiz has all memories unlocked" do

      before(:each) do 
        @memory.view(4)
      end

      it "should not return the quiz with the locked scope" do
        Quiz.locked(@course.id, @student.id).should_not include(@quiz)
      end

      it "should return the quiz with the unlocked scope" do
        Quiz.locked(@course.id, @student.id).all.map{ |q| q.id }.should == []
        Quiz.unlocked(@course.id, @student.id).should include(@quiz)
      end
    end
  end
end
