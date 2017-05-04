RemoteArticleFetcher.setup do |config|
  if Rails.env.test?
    config.fetcher_sequence = [:testing]
  else
    config.fetcher_sequence = [:testing] # TODO-no-commit
  end
end
