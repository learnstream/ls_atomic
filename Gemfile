source 'http://rubygems.org'

gem 'rails', '3.0.7'

gem 'nokogiri', '~> 1.4.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3-ruby', '1.3.2', :require => 'sqlite3'
gem 'sqlite3-ruby', '1.3.2', :group => :development
gem 'authlogic'
gem 'will_paginate', '3.0.pre2'
gem 'escape_utils'
gem 'jquery-rails', '>= 1.0.3'
gem 'paperclip', '~> 2.3'
gem 'time_diff'
gem 'sass'
gem 'timecop'
gem 'omniauth', '0.1.6'
gem 'seed-fu'

group :development, :test do
  gem 'jasmine'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  #Note: I moved timecop out of development group so we can populate on heroku.
end

group :development do
  gem 'rspec-rails', '2.5.0'
end

group :test do
  gem 'webrat', '0.7.1'
  gem 'rspec', '2.5.0'
  gem 'spork', '0.9.0.rc5'
  gem 'factory_girl_rails', '1.0'
end
