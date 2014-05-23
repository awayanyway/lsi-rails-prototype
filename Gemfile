source 'https://rubygems.org'
ruby "1.9.3" # openbabel ruby bindings are not yet ruby-2-compatible

gem "rails", github: "rails/rails", branch: '4-0-stable'

gem "arel", "~> 4.0.0" #, github: "rails/arel"

gem 'rake'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

gem 'uglifier'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :production do 
	gem 'openbabel-heroku', :git => 'git://github.com/Cominch/openbabel-heroku-gem.git'

	gem 'rails_12factor'

  gem 'thin'
end

group :development, :localserver ,:developments3 do
	gem 'openbabel'
end

group :developments3 do
  gem 'fakes3'
  gem 'aws-s3'
  gem 'rest-client'
  gem 'right_aws'  
end

gem 'rubabel'

gem 'jquery-rails'

gem "jquery-hotkeys-rails"

gem 'jquery-ui-rails'

gem 'noVNC', :git => "git://github.com/davidw/noVNCgem.git"

# gem 'audited-activerecord' # rails 4 compatibility

gem 'devise'

gem 'devise_invitable'

gem 'devise_ldap_authenticatable'

gem 'cocoon'

gem 'actionmailer'

gem 'simple_form', github: "plataformatec/simple_form"

#gem 'websocket-rails', :git => 'git://github.com/DanKnox/websocket-rails.git'

gem 'websocket-rails'

# If you want to use dial-a-device-node in a testing environment for developing purpose, clone it into a local directory and point the gem to this copy.
# Make sure to restart your rails server every time you perform any changes.

# Comment out this line if you want to use a local clone of dial-a-device-node
gem 'dial_a_device_node', :git => 'git://github.com/Cominch/dial-a-device-node.git'

# Activate the following line and adjust the path information
# gem 'dial_a_device_node', :path => '/home/user/dial-a-device-node'

gem 'chemrails', :git => 'git://github.com/Cominch/chemrails.git'

gem 'pundit'

gem 'carrierwave'

gem 'unf'

gem 'fog'

gem 'mini_magick'

gem 'carrierwave_direct'

gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'

gem 'bootstrap-wysiwyg-rails'

gem 'httparty'

gem 'protected_attributes'

gem 'dav4rack', github: 'timon/dav4rack'

gem 'rails_serve_static_assets'

gem 'acts_as_list'

gem 'foreman'

gem 'will_paginate', '~> 3.0.5'

gem 'will_paginate-bootstrap'

gem 'rubyzip'

gem 'kaitatari', :git => 'git://github.com/awayanyway/kaitatari.git' # :branch => "ntuple" # :path => ""
