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
      location.try(:creator) == user
    end
    
    # product entries:
    can [:update, :destroy], ProductEntry do |entry|
      entry.location.user_related?(user)
    end
  end
end
