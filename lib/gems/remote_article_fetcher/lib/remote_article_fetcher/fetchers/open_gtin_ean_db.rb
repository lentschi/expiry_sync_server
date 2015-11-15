require 'open-uri'
require 'remote_article_fetcher/fetcher'

module RemoteArticleFetcher  
  module Fetchers
    class OpenGtinEanDb < RemoteArticleFetcher::Fetcher
      def self.fetch(data)
        data = data.deep_dup
        url = "http://opengtindb.org/?ean=#{data[:barcode]}&cmd=query&queryid=300000000"
        Rails.logger.info "Fetching: " + url
        begin
          stream = open(url)
        rescue OpenURI::HTTPError
          Rails.logger.info "Could not fetch url"
        end
        
        return nil if stream.nil?
        
        response_str = stream.read
        response = Hash.new
        response_str.split("\n").each do |line|
          parts_arr = line.split("=")
          next unless parts_arr.length == 2
          response[parts_arr[0].to_sym] = parts_arr[1] 
        end
        
        return nil unless response.has_key?(:error) and response[:error].to_i == 0 \
          and response.has_key?(:name)
          
        data[:name] = response[:name].strip
        data[:producer_attributes] = {name: response[:vendor]} if response.has_key?(:vendor)
        
        data[:images_attributes] = Array.new
        # no images supplied by http://opengtindb.org, so this array will remain empty
          
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