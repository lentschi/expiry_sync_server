$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "remote_article_fetcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remote_article_fetcher"
  s.version     = RemoteArticleFetcher::VERSION
  s.authors     = ["Florian Lentsch"]
  s.email       = ["office@florian-lentsch.at"]
  s.homepage    = "http://www.florian-lentsch.at"
  s.summary     = "fetches articles from remote sites"
  s.description = "fetches article details from remote sites using a barcode as uid"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"

  # s.add_development_dependency "sqlite3"
end
