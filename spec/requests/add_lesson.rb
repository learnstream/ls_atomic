require 'spec_helper'

describe "Lessons" do

  before(:each) do
    @user = Factory(:admin)
    @course = Factory(:course)
    integration_sign_in(@user)
  end

  it "should be accessible from the course page" do
    visit course_path(@course)
    click_link "Lessons"
    page.should have_content("Add a new lesson")
  end

  it "should allow user to create a lesson" do
    visit course_path(@course)
    click_link "Lessons"
    click_link "Add a new lesson"
    fill_in "lesson_name", :with => "First lesson"
    click_button "lesson_submit"
    page.should have_css("h1", :text => "First lesson")
  end

  describe "editing" do
    before(:each) do
      @lesson = Factory(:lesson, :course => @course)
      visit course_path(@course)
      click_link "Lessons"
      click_link "Edit"
    end

    it "should be editable from the lessons index" do 
      page.should have_css("h1", :text => @lesson.name)
    end 

    it "should create a new quiz event", :js => true do
      make_quiz
      page.should have_css("div.event div.question", :text => "A question?")
    end

    it "should switch tabs if needed when editing a quiz", :js => true do
      make_quiz
      make_note
      within "div.quiz" do
        click_link "Edit"
      end
      page.should have_css("a", :href => "#add-quiz", :text => "Edit Quiz")
      page.should have_css("form.edit_quiz")
    end
      
     
    it "should be able to edit a quiz", :js => true do
      make_quiz
      edit_quiz
      page.should have_css("div.event div.question", :text => "Another question")
    end

    it "should be able to create two quizzes in a row", :js => true do
      make_quiz
      make_quiz
      page.should have_css("div.event div.question", :text => "A question?", :count => 2)
    end
    
    it "should be able to edit a quiz then create a new quiz", :js => true do
      make_quiz
      edit_quiz
      make_quiz
      page.should have_css("div.event div.question", :text => "Another question")
      page.should have_css("div.event div.question", :text => "A question?")
    end
    
    it "should be able to create a new note event", :js => true do
      make_note
      page.should have_css("div.event div.content", :text => "A note!")
    end

    it "should be able to edit a note", :js => true do
      make_note
      edit_note
      page.should have_css("div.event div.content", :text => "Another note!")
    end

    it "should switch tabs if needed when editing a note", :js => true do
      make_note
      make_quiz
      within "div.note" do
        click_link "Edit"
      end
      page.should have_css("a", :href => "#add-note", :text => "Edit Note")
      page.should have_css("form.edit_note")
    end

    it "should be able to create two notes in a row", :js => true do
      make_note
      make_note
      page.should have_css("div.event div.content", :text => "A note!", :count => 2)
    end

    it "should be able to edit a note then create a new note", :js => true do
      make_note
      edit_note
      make_note
      page.should have_css("div.event div.content", :text => "A note!")
      page.should have_css("div.event div.content", :text => "Another note!")
    end

    describe "components" do
      before(:each) do
        @component = Factory(:component, :course => @lesson.course)
      end

      it "should have a button for adding components" do
        page.should have_css("a", "Components")
      end

      it "should allow new components to be added", :js => true do
        within("#lesson-edit-tabs") do
          click_link "Components"
        end
        page.execute_script('$("#lesson_component_component_id").val('+@component.id.to_s+')');
        click_button "Submit"
        page.should have_css("li", @component.name)
      end

      it "should allow components to be deleted", :js => true do
        LessonComponent.create(:lesson_id => @lesson.id, :component_id => @component.id)
        visit course_path(@course)
        click_link "Lessons"
        click_link "Edit"

        within("#lesson-edit-tabs") do
          click_link "Components"
        end

        page.should have_css("li", :text => @component.name)

        within("#component-list") do
          click_button "x"
        end

        page.should_not have_css("li", :text => @component.name)
      end
    end
  end
end

def edit_quiz
  click_link "Edit"
  fill_in "Question", :with => "Another question?"
  click_button "quiz_submit"
end

def make_quiz
  if page.has_css?("a", :text => "Add Quiz")
    click_link "Add Quiz"
  end
  fill_in "Start time", :with => 1
  fill_in "End time", :with => 2
  fill_in "Question", :with => "A question?"
  fill_in "Answer", :with => "An answer"
  click_button "quiz_submit"
end

def edit_note
  click_link "Edit"
  fill_in "Content", :with => "Another note!"
  click_button "note_submit"
end

def make_note
  if page.has_css?("a", :text => "Add Note")
    click_link "Add Note"
  end
  fill_in "Start time", :with => 1
  fill_in "End time", :with => 2
  fill_in "Content", :with => "A note!"
  click_button "note_submit"
end
