# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

if Rails.env.development?
  app_enviroment_variables = 
    File.join(Rails.root, 'app_enviroment_variables', 'app_enviroment_variables.rb')
  load(app_enviroment_variables) if File.exist?(app_enviroment_variables)
end
