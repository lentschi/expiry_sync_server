RemoteArticleFetcher.setup do |config|
  config.fetcher_sequence = [:barcoo, :codecheck_info, :open_gtin_ean_db]
end