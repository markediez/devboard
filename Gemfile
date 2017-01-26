source 'https://rubygems.org'

gem 'rails', '~> 5.0'

gem 'sqlite3',        group: [:development, :test]

gem 'sass-rails', '~> 5.0'

gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc, require: false

# Use AR Session Store as required by rubycas-client
gem 'activerecord-session_store', git: 'https://github.com/rails/activerecord-session_store'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.5', require: false
gem 'capistrano-rails',   '~> 1.1', require: false
gem 'capistrano-bundler', '~> 1.1', require: false
gem 'capistrano-passenger', require: false
gem 'capistrano-npm', require: false

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # For using MySQL server during development
  gem 'mysql2'
end

# Use PostgreSQL in production
gem 'pg', group: :production

# E-mail exceptions in production
gem 'exception_notification', group: :production

# Use 'byebug' debugger
gem 'byebug', group: [:development, :test], platform: :mri

# For easy Bootstrap integration
gem 'bootstrap-sass', '~> 3.1.0'
gem 'bootstrap-datepicker-rails'

# For CAS authentication
#gem 'rubycas-client', :git => 'https://github.com/mp-dhorsak/rubycas-client.git'
#gem 'rubycas-client', :git => 'https://github.com/rubycas/rubycas-client.git'
gem 'rubycas-client', :git => 'https://github.com/cthielen/rubycas-client.git'

# For authorization
gem 'cancancan'

# For GitHub integration
gem 'octokit', '~> 4.0'
gem 'faraday-http-cache' # for etag caching with octokit

# For scheduled tasks
gem 'whenever', :require => false

# For Markdown formatting
gem 'redcarpet', :require => false

# For Gravatar profile images
gem 'gravatar_image_tag'

# For Javascript-exposed routes
gem 'js-routes'

# For testing in Rails 5
gem 'rails-controller-testing'

# For Fontawsome icons
gem 'font-awesome-sass'

# For drag and drop
gem 'jquery-ui-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
