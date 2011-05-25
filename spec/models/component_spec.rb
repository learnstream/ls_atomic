require 'spec_helper'

describe Component do
  before(:each) do
    @attr = { :name => "foo", :description => "bar" }
  end

  it "should have a name" do
    no_name_component = Component.new(@attr.merge(:name => ""))
    no_name_component.should_not be_valid
  end    
  
  it "name should be unique" do
    Component.create!(@attr)
    duplicate_component = Component.new(@attr)
    duplicate_component.should_not be_valid
  end  
end
