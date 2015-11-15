require 'open-uri'
require 'remote_article_fetcher/fetcher'

module RemoteArticleFetcher  
  module Fetchers
    class Barcoo < RemoteArticleFetcher::Fetcher
      def self.fetch(data)
        data = data.deep_dup
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
        data[:name] = elem.text.chop.strip
        return nil if data[:name] == "Produkt #{data[:barcode]}" # barcoo acts as if the product exists, returning this dummy name
          
        producerNode = doc.at_css('div#baseDataHolder span[itemprop="manufacturer"]')
        data[:producer_attributes] = {name: producerNode.text.strip} unless producerNode.nil?
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
      
      def self.fetch_barcodes(limit = nil)
        ret_arr = Array.new
        curCount = 0
        curPage = 1
        while limit.nil? or curCount < limit
          url = "https://www.barcoo.com/alle-kategorien?page=#{curPage}"
          Rails.logger.info "Fetching: " + url
          begin
            stream = open(url)
          rescue OpenURI::HTTPError
            Rails.logger.info "Could not fetch url"
            break
          end
          
          doc = Nokogiri::HTML(stream)
          break if doc.nil?
          
          aNodes_arr = doc.css('a.pLstH')
          
          break if aNodes_arr.empty? # barcoo will just show an empty result page when exceeding the max pageCount
          
          aNodes_arr.each do |elem|
            href = elem.attribute('href')
            next if href.nil? or (md = href.value.match('.*\-([0-9]+)$')).nil?
            next if ret_arr.include?(md[1])
            ret_arr << md[1]
            curCount += 1
            break if !limit.nil? and curCount >= limit
          end
          
          curPage += 1
          sleep 0.2
        end
        
        ret_arr
      end
    end
  end
end