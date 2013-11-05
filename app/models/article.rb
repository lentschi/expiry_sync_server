require 'open-uri'

class Article < ActiveRecord::Base
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  
  
  def self.smart_find(data)
    article = self.find_by(barcode: data[:barcode], creator_id: User.current.id) unless User.current.nil?
    return article unless article.nil?
    
    article = self.find_by(barcode: data[:barcode])
    return article unless article.nil?
    

    if data[:name].nil? or data[:name].empty?
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
        
       return self.new(data)
    end
    
    nil
  end
  
  def self.smart_find_or_initialize(data)
    article = smart_find(data)
    return article unless article.nil?
    
    self.new(data)
  end
  
end
