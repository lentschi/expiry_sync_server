RemoteArticleFetcher.setup do |config|
  config.fetcher_sequence = [:barcoo, :codecheck_info]
end