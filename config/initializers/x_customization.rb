LsiRailsPrototype::Application.configure do

if ENV['APPLICATION_NAME'].blank? then
  config.application_name = "LSI"
else
	config.application_name = ENV['APPLICATION_NAME']
end

if ENV['APPLICATION_DATASETROOT'].blank? then
  config.datasetroot = "#{Rails.root}/tmp/storage/"
else
	config.datasetroot = ENV['APPLICATION_DATASETROOT']
end

end

module LsiRailsPrototype
  class Application < Rails::Application
  	if ENV['SMTP_HOST_LINK'].blank? then
  	    config.action_mailer.default_url_options = { :host => 'lsi-rails-prototype.herokuapp.com'}
  	else
  		config.action_mailer.default_url_options = { :host => ENV['SMTP_HOST_LINK']}
  	end

  end
end


Devise.setup do |config|

  if ENV['SMTP_SENDER'].blank? then
  	config.mailer_sender = 'mail@lsi-rails-prototype.herokuapp.com'
  else
  	config.mailer_sender = ENV['SMTP_SENDER']
  end

end