Gretel::Crumbs.layout do
  
  # Remember to restart your application after editing this file.
  
  crumb :root do
    link "Home", root_path
  end

  # Course
  crumb :courses do
    link "Courses", courses_path
  end

  crumb :course do |course|
    link lambda {|course| "#{course.name}"}, course_path(course)
    parent :courses
  end

  crumb :new_course do
    link "New Course", new_course_path
    parent :courses
  end

  crumb :student_status do |course|
    link "Student Status", student_status_course_path(course)
    parent :course, course
  end

  crumb :study do |course|
    link "Study", course_study_index_path(course)
    parent :course, course
  end


  # Lessons
  crumb :lessons do |course|
    link "Lessons", course_lessons_path(course)
    parent :course, course
  end

  crumb :lesson do |lesson|
    link lambda {|lesson| "#{lesson.name}"}, course_lesson_path(lesson.course, lesson)
    parent :lessons, lesson.course
  end

  crumb :lesson_student do |lesson|
    link lambda {|lesson| "Lesson: #{lesson.name}"}, course_lesson_path(lesson.course, lesson)
    parent :course, lesson.course
  end

  crumb :new_lesson do |course|
    link "New Lesson", new_course_lesson_path(course)
    parent :lessons, course
  end

  crumb :edit_lesson do |lesson|
    link lambda {|lesson| "Edit Lesson : #{lesson.name}"}, edit_course_lesson_path(lesson.course, lesson)
    parent :lessons, lesson.course
  end

  # Components
  crumb :components do |course|
    link "Components", course_components_path(course)
    parent :course, course
  end

  crumb :component do |component|
    link lambda {|component| "#{component.name}"}, course_component_path(component.course,component)
    parent :components, component.course
  end

  crumb :component_student do |component|
    link lambda {|component| "Component: #{component.name}"}, course_component_path(component.course,component)
    parent :course, component.course
  end

  crumb :new_component do |course|
    link "New Component", new_course_component_path(course)
    parent :components, course
  end

  crumb :edit_component do |component|
    link "Edit", edit_course_component_path(component.course, component)
    parent :component, component
  end

  # Quizzes
  crumb :quizzes do |course|
    link "Exercises", course_quizzes_path(course)
    parent :course, course
  end

  crumb :quiz do |quiz|
    link lambda {|quiz| "Quiz #{quiz.id}"}, course_quiz_path(quiz.course, quiz)
    parent :course, quiz.course
  end

  crumb :new_quiz do |course|
    link "New Exercise", new_course_quiz_path(course)
    parent :quizzes, course
  end

  #Users
  
  crumb :users do
    link "Users", users_path
  end

  crumb :user do |user|
    link lambda {|user| "#{user.email}"}, user_path(user)
    parent :users
  end
 
end
