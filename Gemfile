source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.9'

# Use sqlite3 as the database for Active Record
#gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'slim-rails', '~> 2.1.5'
gem 'bootstrap-sass', '~> 3.2.0.1'
gem 'simple_form', '~> 3.1.0.rc2'
gem 'pg', '~> 0.17.1'
gem 'ruby-hmac', '~> 0.4.0'
gem 'cybersourcery', git: 'https://efcb6ec0daca0c95d920a44d9789ab56b3a6946c:x-oauth-basic@github.com/promptworks/cybersourcery.git'
#gem 'cybersourcery', path: '/Users/toppa/Projects/cybersourcery'

group :production do
  gem 'rails_12factor', '~> 0.0.2'
end

group :test, :development do
  gem 'capybara', '~> 2.4.1'
  gem 'selenium-webdriver', '~> 2.42.0'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'dotenv-rails'
  gem 'cybersourcery_testing', git: 'https://efcb6ec0daca0c95d920a44d9789ab56b3a6946c:x-oauth-basic@github.com/promptworks/cybersourcery_testing.git'
  #gem 'cybersourcery_testing', path: '/Users/toppa/Projects/cybersourcery_testing'
end

group :test do
  gem 'database_cleaner', '~> 1.3.0'
end


ruby '2.0.0'
