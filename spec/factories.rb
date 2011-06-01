Factory.define :user do |user|
  user.email                 "foo@bar.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :creator, :class => User do |user|
  user.email                  "creator@learnstream.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
  user.perm                   "creator"
end

Factory.define :admin, :class => User do |user|
  user.email                  "admin@learnstream.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
  user.perm                   "admin"
end

Factory.define :course do |course|
  course.name         "TestCourse"
  course.description  "CoolCourse"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :name do |n|
  "Course-#{n}"
end

Factory.define :component do |component|
  component.name            "Newton's First Law"
  component.description     "An object in motion tends to remain in motion, etc."
  component.association     :course_id, :factory => :course
end

Factory.define :problem do |problem|
  problem.name              "Euler's Little Theorem"
  problem.statement         "What is \( e^{\pi i} \) equal to?"
  problem.association       :course_id, :factory => :course
end

Factory.define :step do |step|
  step.name                 "Step 1"
  step.text                 "do this first"
  step.order_number         1
  step.association          :problem, :factory => :problem
end

Factory.define :video do |video|
  video.name                "The Best Video"
  video.url                 "http://www.youtube.com/watch?v=U7mPqycQ0tQ" 
  video.description         "it is awesome"
  video.start_time          0
  video.end_time            60
  video.association         :component, :factory => :component
end
