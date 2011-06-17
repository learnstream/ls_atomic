require 'spec_helper'

describe NotesController do
  render_views

  before(:each) do
    @lesson = Factory(:lesson)
    @event = Factory(:event, :lesson => @lesson)
    @note = Factory(:note)
    @note.events << @event
  end

  describe "POST 'create'" do
    
    before(:each) do 
      @attr = { :content => "I am a new note." }
    end

    it "should be create a new note given valid attributes" do
      lambda do 
        post :create, :lesson_id => @lesson, :note => @attr
      end.should change(Note, :count).by(1)
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @attr = { :content => "I am a changed note." }
    end

    it "should update the attributes given valid attributes" do
      put :update, :id => @note, :note => @attr
      @note.reload
      @note.content.should == "I am a changed note."
    end
  end
    

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :lesson_id => @lesson
      response.should be_success
    end
  end

end
