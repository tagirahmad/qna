# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'active_model_serializers', '~> 0.10.12'
gem 'aws-sdk-s3', '~> 1', require: false
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cancancan'
gem 'cocoon'
gem 'devise'
gem 'doorkeeper'
gem 'dotenv-rails'
gem 'gon', '~> 6.4'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'mysql2', '~> 0.4.10', platform: :ruby
gem 'oj'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4'
gem 'redis-rails'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim-rails'
gem 'thinking-sphinx', git: 'https://github.com/pat/thinking-sphinx.git', branch: 'develop'
gem 'turbolinks', '~> 5'
gem 'unicorn'
gem 'webpacker', '~> 5.0'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'parallel_tests'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'bundler-audit', '~> 0.9.0.1'
  gem 'capistrano', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'reek', '~> 6.1', '>= 6.1.1'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-core'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
