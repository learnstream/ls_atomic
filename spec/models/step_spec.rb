require 'spec_helper'

describe Step do

  before(:each) do
    @attr = { :name => "Step 1", :text => "Think about it"}
  end
  
  describe "failure" do
    it "should require text" do
      no_text_step = Step.new(@attr.merge(:text => ""))
      no_text_step.should_not be_valid
    end

    it "should reject a name that is too long" do
      long_name = "a"*135
      long_name_step = Step.new(@attr.merge(:name => long_name))
      long_name_step.should_not be_valid
    end
  end
end
