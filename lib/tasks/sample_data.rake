namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_courses_and_components
    enroll_users
    make_memories
    make_problems_and_steps
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

def make_memories
  user = User.find_by_email("foo-1@bar.com")
  component = Course.first.components.first
  user.memories.create!(:component_id => component) 
end

def make_problems_and_steps
  course = Course.first
  c1 = course.components[0]
  c2 = course.components[1]
  c3 = course.components[2]
  
  problem1 = course.problems.create!(:name => "Problem 1", :statement => "What is newton's second law?")
  problem2 = course.problems.create!(:name => "Problem 2", :statement => "What is newton's third law?")

  step11 = problem1.steps.create!(:text => "Think about it", :order_number => 1)
  step12 = problem1.steps.create!(:text => "The second law relates force to mass and acceleration", :order_number => 2)
  step13 = problem1.steps.create!(:text => "The answer is \\( \\vec{F} = m\\vec{a} \\) !", :order_number => 3)

  step21 = problem2.steps.create!(:text => "Think about it...", :order_number => 1)
  step22 = problem2.steps.create!(:text => "Every action has an equal and opposite reaction!", :order_number => 2)
  step23 = problem2.steps.create!(:text => "This means that anything exerting a force on something else has an equal force exerted back on itself!", :order_number => 3)

  step12.relate!(c2)
  step13.relate!(c2)

  step22.relate!(c3)
  step23.relate!(c3)
end  
