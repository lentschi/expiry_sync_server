class Article < ActiveRecord::Base
  belongs_to :creator, class_name: "User"
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  
  def before_save(article)
    if article.new?
      article.creator_id = current_user.id
    end
  end
  
  def self.smart_find_or_initialize(current_user, data)
    article = self.find_by(barcode: data[:barcode], creator_id: current_user.id) unless current_user.nil?
    article = self.find_by(barcode: data[:barcode]) if article.nil?
    
    article = self.new(data) if article.nil?
    
    article
  end
  
end
