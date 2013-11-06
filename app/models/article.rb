class Article < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  acts_as_remote_article_fetcher
  
  belongs_to :source, class_name: "ArticleSource", foreign_key: "article_source_id"
  
  def self.smart_find(data)
    article = self.find_by(barcode: data[:barcode], creator_id: User.current.id) unless User.current.nil?
    return article unless article.nil?
           
    article = self.find_by(barcode: data[:barcode])
    return article unless article.nil?
    

    if data[:name].nil? or data[:name].empty?
      data = self.remote_article_fetch(data)
      unless data.nil? or data[:name].nil? or data[:name].empty?
         data[:article_source_id] = ArticleSource.find_or_create_by(name: data[:article_source].to_s).id
         data.delete :article_source
        return self.new(data) 
      end
    end
    
    nil
  end
  
  def self.smart_find_or_initialize(data)
    article = smart_find(data)
    return article unless article.nil?
    
    self.new(data)
  end
  
end
