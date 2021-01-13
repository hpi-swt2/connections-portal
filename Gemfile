source "https://rubygems.org"
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

# Ruby 2.7.2 released 2020-10-02: https://www.ruby-lang.org/en/news/2020/10/02/ruby-2-7-2-released/
ruby '2.7.2'

#
# Rails essentials
#

# The application framework
gem 'rails', '~> 6.0.3', '>= 6.0.3.4' # https://github.com/rails/rails
# Development server
gem 'puma', '~> 5.0', '>= 5.0.2' # https://github.com/puma/puma
# Transpile app-like JavaScript, Webpacker is the default JavaScript compiler for Rails 6
gem 'webpacker', '~> 4.0' # https://github.com/rails/webpacker
# Turbolinks makes navigating your web application faster
# When you follow a link, Turbolinks automatically fetches the page, swaps in its <body>, and merges its <head>
gem 'turbolinks', '~> 5' # https://github.com/turbolinks/turbolinks
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false # https://github.com/Shopify/bootsnap

#
# Additional core gems
#

# Use devise as an authentication solution for Rails with Warden
gem 'devise', '~> 4.7', '>= 4.7.3' # https://github.com/plataformatec/devise
gem 'devise-i18n', '~> 1.9', '>= 1.9.2' # https://github.com/tigrish/devise-i18n
gem 'devise-bootstrap-views', '~> 1.1' # https://github.com/hisea/devise-bootstrap-views

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # https://github.com/tzinfo/tzinfo-data

#
# Packaged JS, CSS libraries and helpers
#

# HTML, CSS, and JavaScript framework for developing responsive, mobile first projects on the web
gem 'bootstrap', '~> 4.5', '>= 4.5.2' # https://github.com/twbs/bootstrap-rubygem
# Provides the Font-Awesome web fonts and stylesheets as a Rails engine for use with the asset pipeline
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.5' # https://github.com/bokmann/font-awesome-rails
# jQuery JavaScript framework packaged for Rails
gem 'jquery-rails', '~> 4.4' # https://github.com/rails/jquery-rails
# State of the art fixtures
gem 'factory_bot_rails', '~> 6.1' # https://github.com/thoughtbot/factory_bot_rails
#
# Gems that depend on the build kind (development/test/production)
#

group :development, :test do
  # Sqlite3 as the database for ActiveRecord.
  gem 'sqlite3', '~> 1.4' # https://www.sqlite.org/index.html
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # https://github.com/deivid-rodriguez/byebug
  # RSpec testing framework as a drop-in alternative to Rails' default testing framework, Minitest
  gem 'rspec-rails', '~> 4.0', '>= 4.0.1' # https://github.com/rspec/rspec-rails
  # Extension of rspec-rails for controller and request specs
  gem 'rails-controller-testing' # https://github.com/rails/rails-controller-testing
  # Ruby static code analyzer (a.k.a. linter) and code formatter
  gem 'rubocop', '~> 0.93.1', require: false # https://github.com/rubocop-hq/rubocop
  # Rails Extension for Rubocop
  gem 'rubocop-rails', '~> 2.8', '>= 2.8.1', require: false # https://github.com/rubocop-hq/rubocop-rails
  # rspec Extension for Rubocop
  gem 'rubocop-rspec', '~> 1.43', '>= 1.43.2', require: false # https://github.com/rubocop-hq/rubocop-rspec
  # Performance optimization analysis for your projects
  gem 'rubocop-performance', '~> 1.8', '>= 1.8.1', require: false # https://github.com/rubocop-hq/rubocop-performance
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code
  gem 'web-console', '>= 3.3.0' # https://github.com/rails/web-console
  # Replaces standard Rails error page with a more useful error page
  gem 'better_errors', '~> 2.8', '>= 2.8.3' # https://github.com/BetterErrors/better_errors
  # binding_of_caller is optional, but is necessary to use Better Errors' advanced features
  gem 'binding_of_caller', '~> 0.8.0' # https://github.com/banister/binding_of_caller
end

group :test do
  # Capybara: Test web applications by simulating how a real user would interact with your app
  gem 'capybara', '~> 3.33' # https://github.com/teamcapybara/capybara/blob/3.33_stable/README.md#using-capybara-with-rspec
  gem 'selenium-webdriver'
  # Run Selenium tests more easily with install and updates for all supported webdrivers
  gem 'webdrivers' # https://github.com/titusfortner/webdrivers
  # Generates fake data (especially useful for tests)
  gem 'faker', '~> 2.14' # https://github.com/faker-ruby/faker
  # Provides one-liners to test common rails functionality, that, if written by hand, would be much longer
  gem 'shoulda-matchers', '~> 4.0' # https://github.com/thoughtbot/shoulda-matchers
  # SimpleCov is a code coverage analysis tool for Ruby
  gem 'simplecov', require: false # https://github.com/simplecov-ruby/simplecov
end

group :production do
  # https://devcenter.heroku.com/articles/sqlite3
  gem "pg" # production database runs on postgres
end
