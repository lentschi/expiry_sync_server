class Article < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  acts_as_remote_article_fetcher
  
  belongs_to :source, class_name: "ArticleSource", foreign_key: "article_source_id"
  belongs_to :producer
  has_many :images, class_name: "ArticleImage"
  
  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :producer
  
  validates :source, :name, presence: true
  validates :barcode, uniqueness: {scope: :creator_id}
  
  def self.smart_find(data)
    article = self.find_by(barcode: data[:barcode], creator_id: User.current.id) unless User.current.nil? or data[:barcode].nil?
    return article unless article.nil? # own article with the specified barcode will be returned even if the names don't match 
           
    if data[:name].nil? or data[:name].empty? # not querying for a specific name...
	    article = self.find_by(barcode: data[:barcode]) unless data[:barcode].nil? # -> check if another user already has fetched an article with that barcode
	    return article unless article.nil?

			# if no article with this barcode could be found so far, search the remotes:
      data = self.remote_article_fetch(data) unless data[:barcode].nil?
      unless data.nil? or data[:name].nil? or data[:name].empty?
        data = self.build_nested_references(data)
        
        # if the remotes have found something, initialize a new article for the local db:
        return self.new(data) 
      end
    else # querying for a specific name...
    	# -> try if anyone has got such an article:
    	article = self.find_by(barcode: data[:barcode], name: data[:name])
	    return article unless article.nil?
    end
    
    # found nothing :-(
    nil
  end
  
  def self.smart_find_or_initialize(data)
    data[:barcode] = nil if data[:barcode].nil? or data[:barcode].empty?
    article = smart_find(data)
    return article unless article.nil?
    
    if data[:images].nil?
      data.delete(:images) 
    else
      data[:images].map! {|imageParams| ArticleImage.decode(imageParams)}
    end
    self.new(data)
  end
  
  def decode_images(params)
    params.each do |imageParams|
      img = ArticleImage.decode(imageParams)
      self.images << img
    end
  end
  
  private
  def self.build_nested_references(data)
    data[:article_source_id] = ArticleSource.find_or_create_by(name: data[:article_source].to_s).id
    data.delete :article_source
    
    producer = Producer.find_by(name: data[:producer_attributes][:name]) unless data[:producer_attributes].nil?
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
