source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use sqlite3 as the database for Active Record

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

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

# auth
gem 'devise'
gem 'devise-i18n'
gem 'sentient_user', git: "git://github.com/bokmann/sentient_user.git"
gem 'clerk', git: "git://github.com/house9/clerk.git"
gem 'cancan'

# views:
gem 'haml'

# html parsing:
gem 'nokogiri'

# deleted flags:
gem 'paranoia'

#CORS:
gem 'rack-cors', :require => 'rack/cors'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :heroku_production_db do
  gem 'pg'
end

group :heroku_production_server do
  gem 'puma'
end


group :production do
  gem 'mysql2', '~> 0.3.10'
  gem 'unicorn'
end

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rails-console'
  gem 'sqlite3'
  gem 'byebug'
  gem 'selenium-webdriver'
end

group :test do
  gem 'rspec-rails', '2.14.0'
  gem 'rspec-core', '2.14.7'
  gem "cucumber", :require => false
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'addressable'
end


gem 'rails_12factor'

gem 'mime-types'
gem 'rails-i18n'
gem 'globalize', '~> 4.0.3'
gem 'globalize-accessors'
gem 'http_accept_language'
gem 'haml-rails'

gem 'remote_article_fetcher', path: "lib/gems/remote_article_fetcher"

ruby "2.1.3"
