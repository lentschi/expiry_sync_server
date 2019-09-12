class ProductEntry < ActiveRecord::Base
  include LegacyIdHandler
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  acts_as_paranoid
  
  belongs_to :article
  belongs_to :location
  
  validates :article, :location, :amount, presence: true
end
