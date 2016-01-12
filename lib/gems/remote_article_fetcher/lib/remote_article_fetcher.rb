require "remote_article_fetcher/acts_as_remote_article_fetcher"

module RemoteArticleFetcher
  mattr_accessor :fetcher_sequence
  @@fetcher_sequence = nil
  
  def self.setup
    yield self
    RemoteArticleFetcher::ActsAsRemoteArticleFetcher.load_config
  end
end