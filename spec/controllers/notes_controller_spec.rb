require 'spec_helper'

describe NotesController do
  render_views

  before(:each) do
    @user = Factory(:user)
    test_sign_in(@user)
    @lesson = Factory(:lesson)
    @event = Factory(:event, :lesson => @lesson)
    @note = Factory(:note)
    @note.events << @event
  end

  describe "POST 'create'" do
    
    before(:each) do 
      @attr = { :content => "I am a new note.",
                :new_event_attributes => { :start_time => 10,
                                           :end_time   => 20,
                                           :video_url  => "http://www.youtube.com/watch?v=-O8gbdt5BLc",
                                           :lesson_id  => @lesson.id,
                                           :order_number => 0 }}
    end

    it "should create a new note given valid attributes" do
      lambda do 
        post :create, :note => @attr
      end.should change(Note, :count).by(1)
    end

    it "should create an event for that note" do
      lambda do
        post :create, :note => @attr
      end.should change(Event, :count).by(1)
    end

    it "should create an association with the new event" do
      post :create, :note => @attr
      new_note = Note.find_by_content("I am a new note.")
      new_note.events.count.should == 1
    end

    it "should have the correct lesson for the new event" do
      post :create, :note => @attr
      new_note = Note.find_by_content("I am a new note.")
      new_note.events[0].lesson.should == @lesson
    end

    it "should automatically assign the right order number to a new event" do
      @attr2 = { :content => "I'm even newer!",
                 :new_event_attributes => { :start_time => 15,
                                            :end_time   => 20,
                                            :video_url  => "http://www.youtube.com/watch?v=-O8gbdt5BLc",
                                            :lesson_id  => @lesson.id }}
      post :create, :note => @attr2
      new_note = Note.find_by_content("I'm even newer!")
      new_note.events[0].order_number.should == 1
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @attr = { :content => "I am a changed note.",
                :existing_event_attributes => { :start_time => 15 } }
    end

    it "should update the attributes given valid attributes" do
      put :update, :id => @note, :note => @attr
      @note.reload
      @note.content.should == "I am a changed note."
    end

    it "should update the attributes for its existing events" do
      put :update, :id => @note, :note => @attr
      @note.reload
      @note.events.first.start_time.should == 15
    end
  end
    
  describe "GET 'new'" do
    it "should be successful" do
      get :new, :lesson_id => @lesson
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => @note, :format => :js
      response.should be_success
    end
  end
end
