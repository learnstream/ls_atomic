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

Factory.sequence :lesson_number do |n|
  n
end

Factory.define :lesson do |lesson|
  lesson_number = Factory.next :lesson_number
  lesson.name         "Lesson #{lesson_number}"
  lesson.order_number lesson_number 
  lesson.association  :course, :factory => :course
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
  component.association :course, :factory => :course
end

Factory.define :problem do |problem|
  problem.name              "Euler's Little Theorem"
  problem.statement         "What is \\( e^{\\pi i} \\) equal to?"
  problem.association :course, :factory => :course
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

Factory.define :answer do |answer|
  answer.text               "42"
end

Factory.define :quiz do |quiz|
  quiz.question           "What is the answer"
  quiz.answer_type        "text"
  quiz.answer_input       '{ "type" : "text" }'
  quiz.answer_output      '{ "type" : "text" }'
  quiz.explanation        "I said so"
  quiz.in_lesson          0
  quiz.association        :course, :factory => :course
  quiz.answers            [Factory(:answer)]
end



Factory.define :text_quiz, :class => Quiz do |quiz|
  quiz.question           "What is the answer?"
  quiz.answer_type        "text"
  quiz.answer_input       '{ "type" : "text" }'
  quiz.answer_output      '{ "type" : "text" }'
  quiz.explanation        "I said so"
  quiz.in_lesson          0
  quiz.association        :course, :factory => :course
  quiz.answers           [Factory(:answer)]
end

Factory.define :self_rate_quiz, :class => Quiz do |quiz|
  quiz.question           "What is the answer?"
  quiz.answer_type        "self-rate"
  quiz.answer_input       '{ "type" : "self-rate" }'
  quiz.answer_output      '{ "type" : "text" }'
  quiz.explanation        "I said so"
  quiz.in_lesson          0
  quiz.association        :course, :factory => :course
  quiz.answers           [Factory(:answer)]
end

Factory.define :response do |r|
  r.answer         "41"
  r.status         "incorrect"
  r.association    :user, :factory => :user
  r.association    :quiz, :factory => :quiz
end

Factory.define :correct_response, :class => Response do |r|
  r.answer         "42"
  r.status         "correct"
  r.association    :user, :factory => :user
  r.association    :quiz, :factory => :quiz
end

Factory.define :note do |note|
  note.content "I am a note"
end

Factory.define :event do |event|
  event.association  :lesson, :factory => :lesson
  event.video_url    "http://www.youtube.com/watch?v=ZwgNbpy9-qU"
  event.start_time   10
  event.end_time     20
  event.order_number 1
end

