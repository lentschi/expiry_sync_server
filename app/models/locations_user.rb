class LocationsUser < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  
  self.primary_keys = :location_id, :user_id
  
  validates_uniqueness_of :user_id, scope: :location_id
end