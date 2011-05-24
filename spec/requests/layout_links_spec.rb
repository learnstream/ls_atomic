require 'spec_helper'
describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should be_success
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should be_success
  end
end
