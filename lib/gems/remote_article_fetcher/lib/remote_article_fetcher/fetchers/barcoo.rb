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
        elem = doc.at_css('div#baseDataHolder h1[itemprop="name"]')
        return nil if elem.nil?
        data[:name] = elem.text
        producerNode = doc.at_css('div#baseDataHolder span[itemprop="manufacturer"]')
        data[:producer_attributes] = {name: producerNode.text} unless producerNode.nil?
        data[:images_attributes] = Array.new
        imageNode = doc.at_css('div#baseDataHolder img[itemprop="image"]')
        unless imageNode.nil? or imageNode.attribute("src").nil?
          url = imageNode.attribute("src").value
          extname = File.extname(url)
          url = url.sub("high"+extname,"low"+extname)
          data[:images_attributes] << {source_url: url}
        end
        
        
        Rails.logger.info "Done fetching "+data.to_yaml.to_s
        
        data
      end
    end
  end
end