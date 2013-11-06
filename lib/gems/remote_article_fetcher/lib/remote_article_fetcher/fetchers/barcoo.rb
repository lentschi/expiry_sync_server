require 'open-uri'
require 'remote_article_fetcher/fetcher'

module RemoteArticleFetcher  
  module Fetchers
    class Barcoo < RemoteArticleFetcher::Fetcher
      def self.fetch(data)
        url = "http://www.barcoo.com/#{data[:barcode]}?source=pb"
        Rails.logger.info "Fetching: " + url
        begin
          stream = open(url)
        rescue OpenURI::HTTPError
          Rails.logger.info "Could not fetch url"
        end
        
        return nil if stream.nil?
        
        doc = Nokogiri::HTML(stream)
        return nil if doc.nil?
        elem = doc.at_css('div#baseDataHolder h1')
        return nil if elem.nil?
        data[:name] = elem.text
        Rails.logger.info "Done fetching"
        
        data
      end
    end
  end
end