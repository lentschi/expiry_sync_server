require 'open-uri'
require 'remote_article_fetcher/fetcher'

module RemoteArticleFetcher  
  module Fetchers
    class CodecheckInfo < RemoteArticleFetcher::Fetcher
      def self.fetch(data)
        url = "http://www.codecheck.info/product.search?q=#{data[:barcode]}&OK=Suchen"
       
        #fetch URL
        Rails.logger.info "Fetching: " + url
        begin
          stream = open(url)
        rescue OpenURI::HTTPError
          Rails.logger.info "Could not fetch url"
        end
        
        return nil if stream.nil?
        
        doc = Nokogiri::HTML(stream)
        return nil if doc.nil?
        elem = doc.at_css('div#pageContent h1')
        return nil if elem.nil?
        data[:name] = elem.text
        Rails.logger.info "Done fetching"
        
        data
      end
    end
  end
end