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

  desc "Add Components to course given by course_id"
  # To call, do rake db:add_components[course_id]
  task :add_components, :course_id do |t, args|
    # removes old components first.
    course = Course.find(args.course_id)
    course.components.destroy_all
    file = File.open("#{Rails.root}/lib/tasks/DataFiles/ComponentsData.txt", "rb")
    contents = file.read
    components = JSON.parse(contents)
    components.each do |c|
      comp = course.components.build(c)
      comp.save
    end
    file.close()
  end
  task :add_components => :environment

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
  course = Course.first
  
  course.components.each do |component|
    quiz = Quiz.create!(:course_id => course,
                 :component_tokens => component.id.to_s,
                 :question => "What is the #{component.id}th answer?",
                 :answer_type => "text",
                 :answer_input => '{ "type" : "text" }',
                 :answer_output => '{ "type" : "text" }')
    quiz.answers.create!(:text => "42")
  end
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

  events = []
  20.times do |n| 
    events << lesson.events.build(:video_url => "http://www.youtube.com/watch?v=us2LKeZnhn0", 
                                  :start_time => n*5,
                                  :end_time => (n+1)*5,
                                  :order_number => n+1)
  end

  note = Note.create!(:content => "Spam that probe, spam it")
  note.events << events[0]

  quiz = Quiz.first
  quiz.events << events[1]

  quiz = Quiz.all[1]
  quiz.events << events[2]

  quiz = Quiz.all[2]
  quiz.events << events[3]
  
  16.times do |n| 
    note = Note.create!(:content => "Spam the nexus")
    note.events << events[n+4]
  end
end
