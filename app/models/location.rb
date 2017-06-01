class Location < ActiveRecord::Base
  track_who_does_it :creator_foreign_key => "creator_id", :updater_foreign_key => "modifier_id"
  acts_as_paranoid

  has_many :locations_users
  has_many :users, through: :locations_users
  has_many :product_entries

  validates :name, presence: true

  # TODO: This doesn't work together with track_who_does_it
  # -> write a custom validator, that fetches the current user manually:
  validates :name, uniqueness: {scope: :creator_id}

  def user_related?(user)
  	self.users.where(id: user.id).length == 1
  end
end
