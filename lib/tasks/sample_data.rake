namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Timecop.travel(2011, 1, 1, 0, 0, 0) do
      make_users
      make_courses
      enroll_users
      
      #add_real_data stuff
      component_map = add_components(1)
      add_lessons(1, component_map)
      add_exercises(1, component_map)

      #make these things for course 2
      create_other_components
      make_quizzes
      make_other_lesson
    end

    view_memories
  end


  desc "Add real data"
  task :add_real_data, :course_id do |t, args|
    component_map = add_components(args.course_id)
    add_lessons(args.course_id, component_map)
  end
  task :add_real_data => :environment

  desc "Add Components as separate task"
  task :add_components, :course_id do |t, args|
    component_map = add_components(args.course_id)
  end
  task :add_components => :environment
  
  desc "Add lessons as separate task"
  task :add_lessons, :course_id do |t, args|
    file = File.open("#{Rails.root}/lib/tasks/DataFiles/ComponentMap.txt", "rb")
    contents = file.read
    component_map = JSON.parse(contents)
    add_lessons(args.course_id, component_map)
  end
  task :add_lessons => :environment

  desc "Print out the component map, need a heroku workaround for no writing to disk"
  task :print_map do
    file = File.open("#{Rails.root}/lib/tasks/DataFiles/ComponentMap.txt", "rb")
    contents = file.read
    component_map = JSON.parse(contents)
    puts component_map
  end

end

def add_exercises(course_id, component_map)
  course = Course.find(course_id)

  file = File.open("#{Rails.root}/lib/tasks/DataFiles/ExerciseData.txt", "rb")
  contents = file.read
  exercises = JSON.parse(contents)
  
  exercises.each do |e|
    component_tokens = e["component_list"].to_s.split(",").map{|e| component_map[e] }
    e["answer_type"] == "text" ? answer_tokens = e["answer"].to_s.split("&") : answer_tokens = [e["answer"].to_s]
    quiz = Quiz.create!(:course_id => course,
                        :in_lesson => true,
                        :answer_type => e["answer_type"],
                        :explanation => e["explanation"],
                        :question => e["question"],
                        :answer_input => { :type => e["answer_type"] }.to_json,
                        :answer_output => { :type => "text" }.to_json)

    component_tokens.each { |c| quiz.components << Component.find(c)} 
    answer_tokens.each { |a| quiz.answers.create!(:text => a ) }
  end

end

def add_lessons(course_id, component_map)
  course = Course.find(course_id)
  course.lessons.destroy_all

  file = File.open("#{Rails.root}/lib/tasks/DataFiles/LessonData.txt", "rb")
  contents = file.read
  lessonEvents = JSON.parse(contents)

  order_number = 0
  created_lessons = []
  lesson = nil

  lessonEvents.each do |lesson_event|
    if !created_lessons.include?(lesson_event["lesson_id"])
      lesson = course.lessons.build(:name => lesson_event["lesson_name"])
      if lesson.save
        created_lessons << lesson_event["lesson_id"]
        order_number = 0
        puts lesson.id
      end
    end 

    event = lesson.events.build(:video_url => lesson_event["video_url"], 
                                :start_time => lesson_event["start_time"],
                                :end_time => lesson_event["end_time"],
                                :order_number => order_number += 1)

 
    if lesson_event["playable_type"] == "Note"
      note = Note.create!(:content => lesson_event["note_content"])
      note.events << event
    elsif lesson_event["playable_type"] == "Quiz"
        component_tokens = lesson_event["component_list"].to_s.split(",").map{|e| component_map[e] }
        lesson_event["answer_type"] == "text" ? answer_tokens = lesson_event["answer"].to_s.split("&") : answer_tokens = [lesson_event["answer"].to_s]
        #is there a better way to do this? I'll admit i'm a bit lost now in the quiz controller/model code. -NP
        quiz = Quiz.create!(:course_id => course,
                 :in_lesson => true,
                 :answer_type => lesson_event["answer_type"],
                 :explanation => lesson_event["explanation"],
                 :question => lesson_event["question"],
                 :answer_input => { :type => lesson_event["answer_type"] }.to_json,
                 :answer_output => { :type => "text" }.to_json)

        component_tokens.each { |c| quiz.components << Component.find(c)} 
        answer_tokens.each { |a| quiz.answers.create!(:text => a ) }
        quiz.events << event
    end
  end
  file.close()
end

def add_components(course_id) 
  # removes old components first.
  course = Course.find(course_id)
  course.components.destroy_all
  file = File.open("#{Rails.root}/lib/tasks/DataFiles/ComponentsData.txt", "rb")
  contents = file.read
  components = JSON.parse(contents)
  component_id_map = Hash.new

  components.each do |c|
    component = course.components.build(c)
    if component.save
      component_id_map["#{c['unique_id']}"] = component.id
    end
  end

  file.close()
  #File.open("#{Rails.root}/lib/tasks/DataFiles/ComponentMap.txt", 'w'){ |f| f.write(component_id_map.to_json) }
  return component_id_map
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

def make_courses
  course1 = Course.create!(:name => "Physics",
                           :description => "is all about the rainbows") 
  course2 = Course.create!(:name => "Writing",
                           :description => "A Post-Lacanian approach to ruby on rails tutorials")
  course3 = Course.create!(:name => "Rithmetic",
                           :description => "numbers and stuff")
 
end

def create_other_components
  course = Course.find_by_name("Writing")

  20.times do |n|
    course.components.create!(:name => "Shakespeare's #{n}th law", :description => "what doth fly up, shouldeth likewise come #{ n.times do
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
  course = Course.find_by_name("Writing")
  
  course.components.each do |component|
    quiz = Quiz.create!(:course_id => course.id, #For some reason, these get created in Physics course unless we do course.id explicitly. go figure.
                 :component_tokens => component.id.to_s,
                 :question => "What is the #{component.id}th answer?",
                 :answer_type => "text",
                 :answer_input => '{ "type" : "text" }',
                 :answer_output => '{ "type" : "text" }')
    quiz.answers.create!(:text => "42")
  end

  component = course.components.first 
  quiz = Quiz.create!(:course_id => course,
               :component_tokens => component.id.to_s,
               :question => "What is the force?",
               :answer_type => "fbd",
               :answer_input => '{ "type" : "fbd", "fb" : {"shape" : "rect-line", "top" : 80, "left" : 80, "width" : 162, "height" : 100, "radius" : 60, "rotation" : -60, "cinterval" : 30}}',
               :answer_output => '{ "type" : "fbd", "fb" : {"shape" : "rect-line", "top" : 80, "left" : 80, "width" : 162, "height" : 100, "radius" : 60, "rotation" : -60, "cinterval" : 30}, "forces" : [{"origin_index" : "8", "ox" : 161, "oy" : 130, "angle" : -90}]}')
  quiz.answers.create!(:text => "8 -90")

end

def view_memories
  course = Course.first
  user = User.find_by_email("foo-1@bar.com")
  user.memories.in_course(course).each do |memory| 
    Timecop.travel(DateTime.now - 30.days) { memory.view(0) }
    Timecop.travel(DateTime.now - 20.days) { memory.view(4) }
    Timecop.travel(DateTime.now - 15.days) { memory.view(0) }
    Timecop.travel(DateTime.now - 12.days) { memory.view(4) }
    Timecop.travel(DateTime.now - 4.days) { memory.view(0) }
  end
end

def make_other_lesson
  course = Course.find_by_name("Writing")
  lesson = Lesson.create!(:course_id => course.id,
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
