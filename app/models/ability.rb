class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # locations:
    can :create, Location
    can :index_mine_changed, Location

    can :read, Location do |location|
      location.user_related?(user)
    end

    can [:update, :destroy], Location do |location|
      location.try(:creator) == user \
        || !Location.exists?(location.id)
    end

    can [:destroy_share], Location do |location, share_user|
      share_user == user \
        || share_user.last_sign_in_at.nil? \
        || share_user.last_sign_in_at + Rails.configuration.locations[:allow_removing_share_after_inactivity_days].days < Time.now
    end

    # alternate servers:
    can [:update, :destroy], AlternateServer do |alternate_server|
      alternate_server.try(:creator) == user
    end

    # product entries:
    can [:update, :destroy, :index_changed], ProductEntry do |entry|
      entry.location.user_related?(user)
    end
  end
end
