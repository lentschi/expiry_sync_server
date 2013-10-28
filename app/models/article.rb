class Article < ActiveRecord::Base
  belongs_to :creator, class_name: "User"
  
  def before_save(article)
    if article.new?
      article.creator_id = current_user.id
    end
  end
  
  def find_or_create(data)
    article = self.find_by(barcode: data[:barcode], creator_id: current_user.id) unless current_user.nil?
    article = self.find_by(barcode: data[:barcode]) if article.nil?
    article = self.create(data) if article.nil?
    
    article
  end
  
end
