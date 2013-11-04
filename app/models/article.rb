require 'open-uri'

class Article < ActiveRecord::Base
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  
  
  def self.smart_find_or_initialize(current_user, data)
    article = self.find_by(barcode: data[:barcode], creator_id: current_user.id) unless current_user.nil?
    article = self.find_by(barcode: data[:barcode]) if article.nil?
    
    if article.nil?
      article = self.new(data)
      
      if article.name.nil? or article.name.empty?
        url = "http://www.barcoo.com/#{data[:barcode]}?source=pb"
        Rails.logger.info "Fetching: " + url
        doc = Nokogiri::HTML(open(url))
        elem = doc.at_css('div#baseDataHolder h1') unless doc.nil?
        article.name = elem.text unless elem.nil?
        Rails.logger.info "Done fetching: " + url
      end
    end
    
    article
  end
  
end
