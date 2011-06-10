require 'spec_helper'

# Most of these should be moved into their respective integration 
# tests, but there aren't integration tests for a lot of actions 
# right now.
 
 
describe 'Navigation' do
  before(:each) do
    @user = Factory(:user)
    @admin = Factory(:admin)
    @course = Factory(:course, :name => "Integration")
    @component = Factory(:component, :course => @course)
    @problem = Factory(:problem, :course => @course)
    @course.components << @component
    @step = Factory(:step, :problem => @problem)
    @quiz = Factory(:quiz, :problem => @problem, :component_tokens => "#{@component.id}") 
    @user.enroll!(@course)
    integration_sign_in(@user)
  end

  describe "the course page" do

    it "should have a back link on the main page" do
      visit home_path
      click_link @course.name
      page.should have_content("Back to home")
    end

    before(:each) do
      visit course_path(@course)
    end

    it "should have back buttons on component pages" do
      click_link @component.name
      click_link "Back to course"
      page.should have_css("h1", @course.name)
    end

    it "should have back buttons on problem pages" do
      click_link @problem.name
      click_link "Back to course"
      page.should have_css("h1", @course.name)
    end

    it "should allow user to return from study mode" do
      click_link "Study"
      click_link "Back to course"
      page.should have_content(@course.name)
    end



    describe "for authorized users" do
      before(:each) do
        click_link "Sign out"
        integration_sign_in(@admin)
        visit course_path(@course)
      end

      it "should have back link from course stats page" do
        click_link "Course statistics"
        click_link "Back to course"
        page.should have_css("h1", @course.name)
      end
      
      it "should have a back link from the new quiz form" do
        click_link "Add quiz"
        click_link "Back to course"
        page.should have_content(@course.name)
      end

      it "should have a back link from the the edit quiz form" do
        click_link "Quiz 1"
        click_link "Back to course"
        page.should have_content(@course.name)
      end

      it "should link back to problem from problem editing form" do
        click_link @problem.name
        click_link "Edit"
        click_link "Back to problem"
        page.should have_content(@problem.name)
      end

      it "should have a back link to the edit probelm page from edit steps" do
        click_link @problem.name 
        click_link "Edit"
        click_link "edit"
        click_link "Back to problem edit"
        page.should have_content("Steps")
      end

      it "should have a back link from component editing form" do
        click_link @component.name
        click_link "Edit"
        click_link "Back to component"
        page.should have_css("h1", :content => @component.name)
      end

      it "should have a back link from the new problem page" do
        click_link "Add problem"
        click_link "Back to course"
        page.should have_css("h1", @course.name)
      end

      it "should have a back link from the new problem(s) with tex page" do
        click_link "Add problem(s) with .tex"
        click_link "Back to course"
        page.should have_css("h1", @course.name)
      end


      it "should have a back link from the new component page" do
        click_link "Add component"
        click_link "Back to course"
        page.should have_css("h1", @course.name)
      end
 
    end
  end
  
  describe "the courses index page" do
    it "should have a back link on the courses page" do
      visit home_path
      click_link "courses"
      click_link "Back to your courses"
      page.should have_content("Courses you are taking")
    end
  end
end
