##using fake-s3 server 

CarrierWave.configure do |config|

    config.storage = :fog
    config.fog_directory = 'dial-a-device'

    config.fog_public = false
    config.fog_authenticated_url_expiration = 10.minutes
    config.fog_use_ssl_for_aws = false
    #config.asset_host = "http://#{config.fog_directory}.s3.amazonaws.com"

    config.fog_credentials = {
      provider: "AWS",
      scheme: 'http',
      aws_access_key_id: "123",
      aws_secret_access_key: "abc",
      region: "us-east-1",
      # region: "eu-west-1",
     # host: 'localhost',
   
      port: 10453
    }

  config.cache_dir = "#{Rails.root}/tmp/upload"

end



LsiRailsPrototype::Application.configure do
  config.useldap = false
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true
  config.dependency_loading = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Do not compress assets
  config.assets.compress = false
  config.assets.compile = true
  config.serve_static_assets = true
  
   config.force_ssl = false

  # See everything in the log (default is :info)
   config.log_level = :debug
  
  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000'}

  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"
end
