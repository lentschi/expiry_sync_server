source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

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
gem 'sentient_user', git: "git://github.com/house9/sentient_user.git"
gem 'clerk', git: "git://github.com/house9/clerk.git"
gem 'cancan'    

# views:
gem 'haml'

# html parsing:
gem 'nokogiri'

# deleted flags:
gem 'paranoia', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'


group :production do
  gem 'mysql2'
  gem 'unicorn'
end

group :development do
	gem 'capistrano-rails'
	gem 'capistrano-rvm'
	gem 'capistrano3-unicorn'
	gem 'capistrano-rails-console'
  gem 'sqlite3'
  gem 'byebug'
end

group :test do
  gem 'rspec-rails'
  gem "cucumber", :require => false
  gem 'cucumber-rails', :require => false
  #gem 'cucumber-api-steps', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'addressable'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'mime-types'

gem 'remote_article_fetcher', path: "lib/gems/remote_article_fetcher"

ruby "2.1.3"
