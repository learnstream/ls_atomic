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

      



end
