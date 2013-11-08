class ArticleSource < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  
  USER_SOURCE = "user_generated"
  
  def self.get_user_source
    self.find_or_create_by(name: USER_SOURCE)
  end
end
