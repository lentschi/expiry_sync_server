class ArticleImage < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  
  belongs_to :article
  belongs_to :source, class_name: "ArticleSource", foreign_key: "article_source_id"

  def self.decode(imageParams)
    img = self.new()
    img.image_data = Base64.decode64(imageParams[:image_data])
    img.mime_type = imageParams[:mime_type]
    img.original_extname = imageParams[:original_extname]
    img.source = ArticleSource.get_user_source

    img
  end
end
