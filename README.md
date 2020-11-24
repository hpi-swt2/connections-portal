# Connections Portal

![build: main](https://github.com/hpi-swt2/connections-portal/workflows/CI_CD/badge.svg?branch=main)
![build: dev](https://github.com/hpi-swt2/connections-portal/workflows/CI_CD/badge.svg?branch=dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

A web application for organizing and arranging networks, relationships and human connections, written in [Ruby on Rails](https://rubyonrails.org/).
Created in the [Software Engineering II course](https://hpi.de/plattner/teaching/winter-term-2020-21/softwaretechnik-ii-agile-software-development-in-large-teams.html) at the HPI in Potsdam.


## Development Setup

* `ruby --version` Ensure Ruby v2.7.2 using [rbenv](https://github.com/rbenv/rbenv) or [RVM](http://rvm.io/)
* `sqlite3 --version` Ensure [SQLite3 database installation](https://guides.rubyonrails.org/getting_started.html#installing-sqlite3)
* `node --version; yarn -v` Ensure [Node.js and Yarn installation](https://guides.rubyonrails.org/getting_started.html#installing-node-js-and-yarn)
* `bundle -v` Ensure [Bundler](https://rubygems.org/gems/bundler) installation (with `gem install bundler`)
* `bundle install --without production && yarn install --check-files` Install dependencies
* `rails db:migrate` Setup the database, run migrations
* `rake devise:create_demo_user` Create a demo user (note _email & password_)
* `rails s` Start the Rails development server (default: _localhost:3000_) and log in using the demo credentials
* `bundle exec rspec` Run the tests (using the [RSpec](http://rspec.info/) test framework)

## Deployment

The tested main branch and dev branch are automatically deployed to Heroku when all tests run successfully. 
Further information on the test runs and deployments can be found in the Github-Actions tab.

You can find the currently deployed main version at [https://connections-portal-main.herokuapp.com/](https://connections-portal-main.herokuapp.com/) and the currently deployed dev version at [https://connections-portal-dev.herokuapp.com/](https://connections-portal-dev.herokuapp.com/).

## Developer Guide

### Cheat Sheets
* [FactoryBot](https://devhints.io/factory_bot)
* [Testing using Capybara](https://devhints.io/capybara)

### Setup
* `bundle exec rails db:migrate RAILS_ENV=development && bundle exec rails db:migrate RAILS_ENV=test` Migrate both test and development databases
* `bundle exec rails assets:clobber && bundle exec rails assets:precompile` Redo asset generation

### Testing
* `bundle exec rspec` Run the full test suite
  * `-f doc` Nicer test output
  * `bundle exec rspec spec/<rest_of_file_path>.rb` Specify a folder or test file to run
  * `-e 'search keyword in test name'` Specify what tests to run dynamically
* `bundle exec rspec --profile` Examine run time of tests

### Linting
* `rake factory_bot:lint` Create each factory and catch any exceptions raised during the creation process (defined in `lib/tasks/factory_bot.rake`)
* `bundle exec rubocop` Use the static code analyzer [RuboCop](https://github.com/rubocop-hq) to find possible issues (based on the community [Ruby style guide](https://github.com/rubocop-hq/ruby-style-guide)).
  * `--auto-correct` to fix what can be fixed automatically.
  * RuboCop's behavior can be [controlled](https://docs.rubocop.org/en/latest/configuration) using `.rubocop.yml`

### Debugging
* `save_and_open_page` within a test to inspect the state of a webpage in a browser
* `rails c --sandbox` Test out some code in the Rails console without changing any data
* `rails dbconsole` Starts the CLI of the database you're using
* `bundle exec rails routes` Show all the routes (and their names) of the application
* `bundle exec rails about` Show stats on current Rails installation, including version numbers

### Generating
* `rails g migration DoSomething` Create migration _db/migrate/*_DoSomething.rb_.

## Generating a Model Class Diagram with RubyMine

RubyMine, an IntelliJ-IDE designed for ruby projects supports generating an uml class diagram from the database scheme. An Instruction can be found here: [https://www.jetbrains.com/help/ruby/creating-diagrams.html#creating-explain-query-plan](https://www.jetbrains.com/help/ruby/creating-diagrams.html#creating-explain-query-plan).
Currently, a file named ```class-diagram.png``` in the projects root folder is linked in this README. So by overwriting this file, or adding a new one to the README, the current model dependencies can be updated.

## Current Model Class Diagram

![](class-diagram.png)