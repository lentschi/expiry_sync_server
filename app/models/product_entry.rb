class ProductEntry < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  
  belongs_to :article
  belongs_to :location
  
  validates :article, :location, :amount, presence: true
end
