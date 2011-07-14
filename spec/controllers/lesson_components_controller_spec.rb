require 'spec_helper'

describe LessonComponentsController do
  render_views

  before(:each) do
    @teacher = Factory(:user)
    @course = Factory(:course)
    @teacher.enroll_as_teacher!(@course)
    test_sign_in(@teacher)

    @lesson = Factory(:lesson, :course => @course)
    @component = Factory(:component, :course => @course)
  end

  describe "POST 'create'" do
    before(:each) do
      @attr = {:component_id => @component.id, :lesson_id => @lesson.id }
    end

    it "should create a new lesson component" do
      lambda do
        post :create, :lesson_component => @attr
      end.should change(LessonComponent, :count).by(1)
    end

    it "should not allow duplicate lesson components" do
      lambda do 
        post :create, :lesson_component => @attr
        post :create, :lesson_component => @attr
      end.should_not change(LessonComponent, :count).by(2)
    end

    it "should not create a lesson component without a lesson" do
      @attr.delete(:lesson_id) 
      lambda do
        post :create, :lesson_component => @attr
      end.should_not change(LessonComponent, :count).by(1)
    end

    it "should not create a lesson component without a component" do
      @attr.delete(:component_id)
      lambda do
        post :create, :lesson_component => @attr
      end.should_not change(LessonComponent, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @lc = LessonComponent.create!(:lesson_id => @lesson.id, :component_id => @component.id)
    end

    it "should destroy the given lesson component" do
      lambda do
        delete :destroy, :id => @lc
      end.should change(LessonComponent, :count).by(-1)
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @lc = LessonComponent.create!(:lesson_id => @lesson.id, :component_id => @component.id)
      @event = Factory(:event, :lesson => @lesson)

      @attr = { :event_id => @event.id }
    end


    it "should update the attributes for a lesson component" do
      put :update, :id => @lc, :lesson_component => @attr

      @lc.reload
      @lc.event.should == @event
    end
  end
end
