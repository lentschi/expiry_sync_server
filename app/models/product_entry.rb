class ProductEntry < ActiveRecord::Base
  belongs_to :article
  belongs_to :location
  belongs_to :creator, :class_name => 'User'
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
end
