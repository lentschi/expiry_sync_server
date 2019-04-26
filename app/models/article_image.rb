class ArticleImage < ActiveRecord::Base
  include LegacyIdHandler
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  
  belongs_to :article
  belongs_to :source, class_name: "ArticleSource", foreign_key: "article_source_id"

  def self.decode(imageParams)
    img = self.new()
    img.image_data = Base64.decode64(imageParams[:image_data])
    img.shrink
    img.mime_type = imageParams[:mime_type]
    img.original_extname = imageParams[:original_extname]
    img.source = ArticleSource.get_user_source

    img
  end

  def shrink()
    return self if self.image_data.length <= 20000
    begin
      image = Magick::Image.from_blob(self.image_data).first
    rescue 
      Rails.logger.error  "Error converting image with id #{self.id} for shrinking"
      return self
    end

    if image.columns > 200 or image.rows > 350
      image.resize_to_fit!(200,350)
    end

    self.image_data = image.to_blob
    if self.image_data.length > 20000
      self.image_data = image.to_blob {|writer| writer.quality = 20}
    end

    self
  end

  def shrink!()
    self.shrink
    save
  end
end
