namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_courses_and_components
  end
end

def make_users
  user = User.create!(:email => "foo@bar.com",
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
