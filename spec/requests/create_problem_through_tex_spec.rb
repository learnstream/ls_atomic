require 'spec_helper'

describe "Tex problem creation" do

  before(:each) do
    @user = Factory(:admin)
    @course = Factory(:course)
    integration_sign_in(@user)
  end

  it "should allow user to accessTeX page" do
    visit course_path(@course)
    click_link "Problems"
    click_link "Edit Course"
    page.should have_content(".tex")
  end

  it "should properly add problem statement" do
    visit course_path(@course)
    click_link "Edit Course"
    fill_in "course[document]", :with => "\\begin{course[document]} 
                              \\begin{problem}
                              \\begin{statement} This is the problem statement.\\end{statement}
                              \\end{problem}
                              \\end{course[document]}" 
    click_button "Submit"
    click_link "Problems"
    page.should have_css("td", :content => " This is the problem statement.")
  end

  it "should properly add problem name" do
    visit course_path(@course)
    click_link "Edit Course"
    fill_in "course[document]", :with => "\\begin{course[document]} 
                              \\begin{problem}
                              \\begin{name} problem numero uno
                              \\end{name}
                              \\begin{statement} This is the problem statement.\\end{statement}
                              \\end{problem}
                              \\end{course[document]}" 
    click_button "Submit"
    click_link "Problems"
    page.should have_content("problem numero uno")
  end

  it "should properly add a problem step" do
    visit course_path(@course)
    click_link "Problems"
    click_link "Edit Course"
    fill_in "course[document]", :with => "\\begin{course[document]} 
                              \\begin{problem}
                              \\begin{statement} This is the problem statement.\\end{statement}
                              \\begin{step} This is the first step.\\end{step}
                              \\end{problem}
                              \\end{course[document]}" 
    click_button "Submit"
    page.should have_css("li", " This is the first step.")
  end

  it "should throw out any header stuff" do 
    visit course_path(@course)
    click_link "Problems"
    click_link "Edit Course"
    fill_in "course[document]", :with => "#include amsmath
                              \\begin{course[document]} 
                              \\begin{problem}
                              \\begin{statement} This is the problem statement.\\end{statement}
                              \\begin{step} This is the first step.\\end{step}
                              \\end{problem}
                              \\end{course[document]}" 
    click_button "Submit"
    page.should_not have_content("amsmath")
  end

  it "should not include the slash begin stuff" do
    visit course_path(@course)
    click_link "Problems"
    click_link "Edit Course"
    fill_in "course[document]", :with => "#include amsmath
                              \\begin{course[document]} 
                              \\begin{problem}
                              \\begin{statement} This is the problem statement.\\end{statement}
                              \\begin{step} This is the first step.\\end{step}
                              \\end{problem}
                              \\end{course[document]}" 
    click_button "Submit"
    page.should_not have_content("\\begin")
  end

  it "should allow multiple questions to be made" do
    visit course_path(@course)
    click_link "Problems"
    click_link "Edit Course"
    fill_in "course[document]", :with => "#include amsmath
                              \\begin{course[document]} 
                              \\begin{problem}
                              \\begin{statement} This is the problem statement.\\end{statement}
                              \\begin{step} This is the first step.\\end{step}
                              \\end{problem}
                              \\begin{problem}
                              \\begin{statement}
                              this is the problem statement for problem 2
                              \\end{statement}
                              \\end{problem}
                              \\end{course[document]}" 
    click_button "Submit"
    page.should have_content("this is the problem statement for problem 2")
  end

#  it "should properly remove problems already created on an error" do
#    visit course_path(@course)
#    click_link "Problems"
#    click_link "Edit Course"
#    fill_in "course[document]", :with => "#include amsmath
#                              \\begin{course[document]} 
#                              \\begin{problem}
#                              \\begin{statement} Something very different.\\end{statement}
#                              \\begin{step} This is the first step.\\end{step}
#                              \\end{problem}
#                              \\begin{problem}
#                              \\begin{sttement}
#                              this is the problem statement for problem 2
#                              \\end{statement}
#                              \\end{problem}
#                              \\end{course[document]}" 
#    click_button "Submit"
#    page.should_not have_content("Something very different")
#  end
end
