require 'spec_helper'

describe Course do
  before(:each) do
    @course = Factory(:course)
  end
  
  describe "enrollments" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should have an enrollments method" do
      @course.should respond_to(:enrollments)
    end
  end
end
