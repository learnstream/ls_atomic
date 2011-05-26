namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_courses_and_components
    enroll_users
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
                         :description => "F = ma")
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
