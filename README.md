ExpirySync - Ruby on Rails API server
==

## Installation

- [Install ruby](https://www.ruby-lang.org/en/documentation/installation/) (v2.1 +)
- Install required dependencies using __bundler__: `gem install bundler && bundle install`
- Configure database access by copying `config/database.yml.skel` to `config/database.yml` and adepting it to your needs.
- Create the empty database by running `bundle exec rake db:create` and `bundle rake db:schema:load`

## Running the server

Just run `bundle exec rails s`

## Deployment

### Using capistrano

There are Some `.skel` files you need to copy and configure:

- `Capfile.skel` - The example is configured to use unicorn and include the rails console.
- `config/deploy/production.skel` - add your production server
- `config/deploy/staging.skel` - add your staging server

To deploy on your production server you may run: `cap production deploy`

### Using any other tool

It is up to you really - If you don't own your own server, you might want to give [Heroku](http://www.heroku.com) a try.

