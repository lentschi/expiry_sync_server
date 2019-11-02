source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'

# s. https://stackoverflow.com/questions/35893584 :
gem 'rake', '< 11.0'

gem "composite_primary_keys", "~> 11.0"

# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", "~> 4.1"

# Use CoffeeScript for .js.coffee assets and views
gem "coffee-rails", "~> 4.2"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem "therubyracer", "~> 0.12.3", platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails", "~> 4.3"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', "~> 5.2"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

# auth
gem "devise", "~> 4.7"
gem "devise-i18n", "~> 1.6"
gem "sentient_user", "~> 0.4.0"
# gem 'sentient_user', git: "git://github.com/bokmann/sentient_user.git"
gem "clerk", "~> 1.0"
# gem 'clerk', git: "git://github.com/house9/clerk.git"
gem "cancancan", "~> 2.2"

# views:
gem "haml", "~> 5.0"
gem "haml-rails", "~> 1.0"

# html parsing:
gem "nokogiri", "~> 1.8"

# deleted flags:
gem "paranoia", "~> 2.4"

# CORS:
gem "rack-cors", "~> 1.0", :require => 'rack/cors'

# Impressionist:
gem "impressionist", "~> 1.6"

gem "tzinfo-data"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", "~> 1.0", require: false
end

group :heroku do
  gem 'puma'
end

gem 'mysql2', '~> 0.5.2', group: [:local_docker_compose, :heroku]

group :production do
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
  gem 'thin'
end

group :test do
  gem 'rspec-rails', '2.14.0'
  gem 'rspec-core', '2.14.7'
  gem "cucumber", :require => false
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'addressable'
end


gem "mime-types", "~> 3.2"
gem "rails-i18n", "~> 5.1"
gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'globalize-accessors', git: 'https://github.com/globalize/globalize-accessors'
gem "http_accept_language", "~> 2.1"
gem "open_uri_redirections", "~> 0.2.1"
gem "rmagick", "~> 2.16"

gem 'remote_article_fetcher', path: "lib/gems/remote_article_fetcher"

ruby "2.5.1"
