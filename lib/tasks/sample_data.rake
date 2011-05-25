namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_components
  end
end

def make_users
  user = User.create!(:email => "foo@bar.com",
                      :password => "foobar",
                      :password_confirmation => "foobar")
end

def make_components
  c1 = Component.create!(:name => "Newton's first law",
                         :description => "An object in motion remains in motion")  
  c2 = Component.create!(:name => "Newton's second law",
                         :description => "F = ma")
  c3 = Component.create!(:name => "Newton's third law",
                         :description => "Every action has an opposite and equal reaction")
end