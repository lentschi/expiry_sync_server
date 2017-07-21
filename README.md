ExpirySync - Ruby on Rails API server
==

## Project

This is just the server;
There's a wrapper project including the __API docs__ as well as both server and client as submodules at [https://github.com/lentschi/expiry_sync](https://github.com/lentschi/expiry_sync).

The server is licensed under the [GPLv3](LICENSE.md).

## Installation

- [Install ruby](https://www.ruby-lang.org/en/documentation/installation/) (v2.1 +)
- Install required dependencies using __bundler__: `gem install bundler && bundle install` (or instead `bundle install --without heroku_production_server docker_production_db heroku_production_db production`, if you're on a development server)
- Configure database access by copying `config/database.yml.skel` to `config/database.yml` and adepting it to your needs.
- Configure cookie singing by copying `config/initializers/secret_token.rb.skel` to `config/initializers/secret_token.rb` and inserting the output of `bundle exec rake secret`.
- Create the empty database by running `bundle exec rake db:create` and `bundle rake db:schema:load`

## Running the server

Just run `bundle exec rails s`

## Testing

Only cucumber tests for now -> run:

```bash
bundle exec cucumber
```

## Deployment

### Using capistrano

There are Some `.skel` files you need to copy and configure (The examples are configured to use unicorn and include the rails console):

- `Capfile.skel`
- `config/deploy.rb`: change `repo_url` to your fork
- `config/deploy/production.skel`: add your production server
- `config/deploy/staging.skel`: add your staging server

To deploy on your production server you may run: `cap production deploy`

### Using any other tool

It is up to you really - If you don't own your own server, you might want to give [Heroku](http://www.heroku.com) a try.

