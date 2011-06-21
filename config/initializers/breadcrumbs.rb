Gretel::Crumbs.layout do
  
  # Remember to restart your application after editing this file.
  
  crumb :root do
    link "Home", root_path
  end

  crumb :courses do
    link "Courses", courses_path
  end

  crumb :course do |course|
    link lambda {|course| "#{course.name}"}, course_path(course)
    parent :courses
  end

  crumb :course_edit do |course|
    link "Edit", course_edit_path(course)
    parent :courses, course
  end

  crumb :course_lessons do |course|
    link "Lessons", course_lessons_path(course)
    parent :course, course
  end

  crumb :edit_course_lesson do |lesson|
    link lambda {|lesson| "Edit Lesson : #{lesson.name}"}, edit_course_lesson_path(lesson.course, lesson)
    parent :course_lessons, lesson.course
  end
  
  # crumb :projects do
  #   link "Projects", projects_path
  # end
  
  # crumb :project do |project|
  #   link lambda { |project| "#{project.name} (#{project.id.to_s})" }, project_path(project)
  #   parent :projects
  # end
  
  # crumb :project_issues do |project|
  #   link "Issues", project_issues_path(project)
  #   parent :project, project
  # end
  
  # crumb :issue do |issue|
  #   link issue.name, issue_path(issue)
  #   parent :project_issues, issue.project
  # end

end
