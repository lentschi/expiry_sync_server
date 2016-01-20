class AlternateServer < ActiveRecord::Base
  track_who_does_it creator_foreign_key: "creator_id", updater_foreign_key: "modifier_id"
  acts_as_paranoid
  
  translates :name, :description
  globalize_accessors
  
  validates :url, presence: true, uniqueness: true, :format => URI::regexp(%w(http https))
end
