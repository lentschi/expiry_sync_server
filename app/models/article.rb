class Article < ActiveRecord::Base
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  
  
  def self.smart_find_or_initialize(current_user, data)
    article = self.find_by(barcode: data[:barcode], creator_id: current_user.id) unless current_user.nil?
    article = self.find_by(barcode: data[:barcode]) if article.nil?
    
    article = self.new(data) if article.nil?
    
    article
  end
  
end
