CarrierWave.configure do |config|

  config.storage = :file

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

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = true

  config.action_mailer.default_url_options = { :host => 'localhost:5000'}

  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # Jdx file support through kaitatari : options
  config.jdx_support.cw_thumbnail     = true      #carrierwave thumbnail creation   in uploaders/attachment_uploader
  config.jdx_support.detect_jdx       = true      # detect file extension jdx and  parameters in model/dataset::detect_parameters  
  config.jdx_support.interactive_plot = true      #interactive plot of the jdx data in view/datasets/show 
end
