# config/initializers/system.rb

if ENV['RAILS_LOG_TO_STDOUT'] == '1'
  stdout_logger = Logger.new($stdout)
  stdout_logger.formatter = Logger::Formatter.new
  logger = ActiveSupport::TaggedLogging.new(stdout_logger)
else
  logger = nil
end

# To set a default tag for the logger, do this
# logger.push_tags('xxx')

Dry::Rails.container do
  register 'logger', logger

  auto_register!('app/processors')
  auto_register!('app/drivers')
end

if ENV['RAILS_LOG_AR_TO_STDOUT'] == '1'
  ActiveRecord::Base.logger = logger
end
