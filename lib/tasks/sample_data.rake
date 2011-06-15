namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Timecop.travel(2011, 1, 1, 0, 0, 0) do
      make_users
      make_courses_and_components
      enroll_users
      make_quizzes
      create_many_components
      make_lesson
    end

    view_memories
  end
end

def make_users
  user = User.create!(:email => "admin@admin.com",
                      :password => "foobar",
                      :password_confirmation => "foobar")
  user.perm = "admin"
  user.save

  10.times do |n|
    User.create!(:email => "foo-#{n+1}@bar.com",
                 :password => "foobar",
                 :password_confirmation => "foobar")
  end

  users = User.all
  users[1].perm = "creator"
  users[1].save

  teacher = User.create!(:email => "teacher@teacher.com",
                         :password => "foobar",
                         :password_confirmation => "foobar")
  
end

def make_courses_and_components
  course1 = Course.create!(:name => "Reading",
                           :description => "rainbows") 
  course2 = Course.create!(:name => "Writing",
                           :description => "A Post-Lacanian approach to ruby on rails tutorials")
  course3 = Course.create!(:name => "Rithmetic",
                           :description => "numbers and stuff")
  c1 = course1.components.create!(:name => "Newton's first law",
                         :description => "An object in motion remains in motion")  
  c2 = course1.components.create!(:name => "Newton's second law",
                         :description => "\\( \\vec{F} = m\\vec{a} \\)")
  c3 = course1.components.create!(:name => "Newton's third law",
                         :description => "Every action has an opposite and equal reaction")
  
end

def create_many_components
  course = Course.find(1)

  20.times do |n|
    course.components.create!(:name => "Newton's #{n}th law", :description => "what comes up, must come #{ n.times do
                                                                                                              "down"
                                                                                                            end }")
  end
end


def enroll_users

  users = User.all
  normal_users = User.where("email LIKE ?", "%bar.com")
  teacher = User.find_by_email("teacher@teacher.com")
  
  courses = Course.all

  teacher.enroll_as_teacher!(courses[0])
  normal_users[0..2].each { |u| u.enroll!(courses[0]) }
  normal_users[3..5].each { |u| u.enroll!(courses[1]) }
  normal_users[6..8].each { |u| u.enroll!(courses[2]) }
end

def make_quizzes
  quiz = Quiz.create!(:course_id => Course.first,
                      :component_tokens => "2",
                      :question => "What is the answer?",
                      :answer_type => "text",
                      :answer_input => '{ "type" : "text" }',
                      :answer => "42",
                      :answer_output => '{ "type" : "text" }')
end

def view_memories
  course = Course.first
  user = User.find_by_email("foo-1@bar.com")
  user.memories.in_course(course).each do |memory| 
    Timecop.travel(DateTime.now - 30.days) { memory.view(0) }
    Timecop.travel(DateTime.now - 20.days) { memory.view(4) }
    Timecop.travel(DateTime.now - 20.days) { memory.view(4) }
    Timecop.travel(DateTime.now - 10.days) { memory.view(4) }
    Timecop.travel(DateTime.now - 10.days) { memory.view(0) }
    Timecop.travel(DateTime.now - 10.days) { memory.view(0) }
  end
end

def make_lesson
  course = Course.first
  lesson = Lesson.create!(:course_id => course,
                          :name => "Newton's Laws")
  event = lesson.events.build(:video_url => "http://www.youtube.com/watch?v=us2LKeZnhn0", 
                              :start_time => 0,
                              :end_time => 20,
                              :order_number => 1)

  note = Note.create!(:content => "Spam that probe, spam it")
  note.events << event

end
