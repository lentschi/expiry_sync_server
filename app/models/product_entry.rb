class ProductEntry < ActiveRecord::Base
  belongs_to :article
  belongs_to :creator, :class_name => 'User'
  
  def before_save(article)
      if article.new?
        article.creator_id = current_user.id
      end
  end
end
