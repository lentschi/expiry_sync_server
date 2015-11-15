require 'open-uri'
require 'remote_article_fetcher/fetcher'

module RemoteArticleFetcher  
  module Fetchers
    class CodecheckInfo < RemoteArticleFetcher::Fetcher
      BASE_URL = "http://www.codecheck.info"
      
      def self.fetch(data)
        data = data.deep_dup
        
        url = "#{BASE_URL}/product.search?q=#{data[:barcode]}&OK=Suchen"
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
        elem = doc.at_css('div.page-title h1')
        return nil if elem.nil?
        data[:name] = elem.text.strip
        return nil if data[:name] == "Suchresultate #{data[:barcode]}" # codecheck info acts as if the product exists, returning this dummy name
        
        data[:images_attributes] = Array.new
        imageNode = doc.at_css('div.product-image img')
        unless imageNode.nil? or imageNode.attribute("src").nil?
          url = imageNode.attribute("src").value
          if url.start_with?('/')
            url = BASE_URL + url
          elsif not url.start_with?('http')
            url = BASE_URL + '/' + url
          end

          data[:images_attributes] << {source_url: url}
        end  
        
        doc.css('div.product-info-item').each do |infoNode|
          labelNode = infoNode.at_css('p.product-info-label')
          next if labelNode.nil? or labelNode.text != "Hersteller / Vertrieb" or labelNode.next_element.nil?
          
          data[:producer_attributes] = {name: labelNode.next_element.text.strip}
          break
        end
          
          
        Rails.logger.info "Done fetching"
        
        data
      end
      
      def self.fetch_barcodes(limit = nil)
        ret_arr = Array.new
        # TODO: not yet implemented
        ret_arr
      end
    end
  end
end