require 'spec_helper'

describe MemoryRating do

  before(:each) do
    @user = Factory(:user)
    @component = Factory(:component)

    @memory = @user.memories.build(:component_id => @component.id)
    @memory.save
    @quality = 4
    @memory.view(@quality)
    @memory_rating = @memory.memory_ratings.first
  end

  it "should be created when memories are rated" do
    @memory_rating.should_not be_nil
  end 
  
  it "should have the correct quality" do
    @memory_rating.quality.should == @quality
  end

  it "should belong to a memory" do
    @memory_rating.memory.should == @memory
  end
end
