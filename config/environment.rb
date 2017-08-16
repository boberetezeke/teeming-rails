# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USER_NAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => 'prettygoodprogress.org',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttle_auto => true
}

if !Rails.env.development?
  Rails.logger = Le.new(ENV['LOGENTRIES_TOKEN'])
end
