source 'https://rubygems.org'

gem 'rails', '~> 4.2.3'

gem 'sqlite3',        group: :development

gem 'sass-rails', '~> 4.0.0.rc1'

gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc, require: false

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/jonleighton/spring
gem 'spring',        group: :development

# Web console for debugging in Rails 4.2
gem 'web-console', '~> 2.0', group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use AR Session Store as required by rubycas-client
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

# Use Capistrano for deployment
#gem 'capistrano-rails', group: :development
group :development do
  gem 'capistrano', '~> 3.1', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-npm', require: false
end

# Use PostgreSQL in production
gem 'pg', group: :production

# E-mail exceptions in production
gem 'exception_notification', group: :production

# Use 'byebug' debugger
gem 'byebug', group: [:development, :test]

# For easy Bootstrap integration
gem 'bootstrap-sass', '~> 3.1.0'

# For CAS authentication
#gem 'rubycas-client', :git => 'https://github.com/mp-dhorsak/rubycas-client.git'
#gem 'rubycas-client', :git => 'https://github.com/rubycas/rubycas-client.git'
gem 'rubycas-client', :git => 'https://github.com/cthielen/rubycas-client.git'

# For authorization
gem 'cancan'

# For GitHub integration
gem 'octokit'
gem 'faraday-http-cache' # for etag caching with octokit

# For scheduled tasks
gem 'whenever', :require => false

# For Markdown formatting
gem 'redcarpet', :require => false

# For Gravatar profile images
gem 'gravatar_image_tag'
