RemoteArticleFetcher.setup do |config|
  if Rails.env.test?
    config.fetcher_sequence = [:testing]
  else
    config.fetcher_sequence = [:barcoo, :codecheck_info, :open_gtin_ean_db]
  end
end