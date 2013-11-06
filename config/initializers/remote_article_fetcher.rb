RemoteArticleFetcher.setup do |config|
  config.fetcher_sequence = [:codecheck_info, :barcoo]
end