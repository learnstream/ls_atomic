require 'spec_helper'

describe Video do

  before(:each) do
    @component = Factory(:component)
    @attr = { :url => "http://www.youtube.com/watch?v=U7mPqycQ0tQ", :start_time => 0, :end_time => 25 }
  end

  it "should create a video with the right URL" do
    lambda do
      @video = @component.videos.build(@attr)
      @video.save!
    end.should change(Video, :count).by(1)
  end



end
