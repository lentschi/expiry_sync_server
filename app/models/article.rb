class Article < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  acts_as_remote_article_fetcher
  
  belongs_to :source, class_name: "ArticleSource", foreign_key: "article_source_id"
  belongs_to :producer
  has_many :images, class_name: "ArticleImage"
  
  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :producer
  
  validates :barcode, :source, :name, presence: true
  validates :barcode, uniqueness: {scope: :creator_id}
  
  def self.smart_find(data)   
    article = self.find_by(barcode: data[:barcode], creator_id: User.current.id) unless User.current.nil?
    return article unless article.nil?
           
    article = self.find_by(barcode: data[:barcode])
    return article unless article.nil?
    

    if data[:name].nil? or data[:name].empty?
      data = self.remote_article_fetch(data)
      unless data.nil? or data[:name].nil? or data[:name].empty?
        data = self.build_nested_references(data)
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
  
  def decode_images(params)
    params.each do |imageParams|
      img = ArticleImage.new
      img.image_data = Base64.decode64(imageParams[:image_data])
      img.mime_type = imageParams[:mime_type]
      img.original_extname = imageParams[:original_extname]
      img.source = ArticleSource.get_user_source
      self.images << img
    end
  end
  
  private
  def self.build_nested_references(data)
    data[:article_source_id] = ArticleSource.find_or_create_by(name: data[:article_source].to_s).id
    data.delete :article_source
    
    producer = Producer.find_by(name: data[:producer_attributes][:name])
    unless producer.nil?
      data[:producer_id] = producer.id
      data.delete :producer_attributes
    end
    
    data[:images_attributes].each do |attrib|
      attrib[:article_source_id] = ArticleSource.find_or_create_by(name: attrib[:article_source].to_s).id
      attrib.delete :article_source
    end
    
    data
  end
  
end
