require 'spec_helper'

describe Memory do

  before(:each) do
    @user = Factory(:user)
    @component = Factory(:component)

    @memory = @user.memories.build(:component_id => @component.id)
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
    @memory.ease.should == 2.5
  end

  it "should default to 1.0 interval" do
    @memory.interval.should == 1.0
  end

  it "should default to being due today" do 
    @memory.due.to_date.should == Date.today
  end

  it "should default to having never been viewed" do
    @memory.last_viewed.should be_nil
  end
end
