class Producer < ActiveRecord::Base
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  
  validates :name, presence: true
end
