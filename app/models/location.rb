class Location < ActiveRecord::Base
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  acts_as_paranoid
  
  has_and_belongs_to_many :users
  
  validates :uuid, :name, presence: true
end
