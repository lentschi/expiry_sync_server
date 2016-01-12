class ArticleImage < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  
  belongs_to :article
  belongs_to :source, class_name: "ArticleSource", foreign_key: "article_source_id"
end
