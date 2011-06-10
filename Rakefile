# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

# We don't necessarily want this definition in the long run, but it makes rake 
# work on Heroku right now (6/10/11)
require 'rake/dsl_definition' 
require 'rake'

class Rails::Application
    include Rake::DSL if defined?(Rake::DSL)
end

LsAtomic::Application.load_tasks
