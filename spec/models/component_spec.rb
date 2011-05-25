require 'spec_helper'

describe Component do
  before(:each) do
    @attr = { :name => "", :description => "hello" }
    @invalid_component = Component.create(@attr)
    @component = Factory(:component)
  end

  it "should have a name" do
    @invalid_component.should_not be_valid
  end    
    
end
