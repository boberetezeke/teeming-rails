source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# UI Gems
gem 'jquery-rails'
gem 'turbograft'
gem 'devise'
gem 'pundit'
gem 'haml'
gem 'formtastic', '~> 3.0'
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'bootstrap-datepicker-rails'
gem 'formtastic-bootstrap' #, git: 'git://github.com/0xCCD/formtastic-bootstrap.git'
gem 'rails_admin'
gem 'responders'
gem 'kramdown'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'select2-rails'
gem 'dynamic_table', git: 'https://github.com/boberetezeke/dynamic_table.git'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'geocoder'
gem 'acts-as-taggable-on', '~> 6.0'

gem 'active_model_serializers', '~> 0.10.0'
gem 'jwt', '>= 1.5.6'
gem 'kaminari'
gem 'pry-rails'
gem 'sendgrid-ruby'
gem 'aws-sdk-s3', '~> 1'

gem 'honeybadger'

gem 'delayed_job_active_record'
gem 'daemons'
# gem 'sidekiq'

gem 'dotenv-rails', groups: [:development, :test]

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :production do
  gem 'le'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'timecop'
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'timecop'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
