class Ability
  include CanCan::Ability
  
  def initialize(user)
    return if user.nil?
    
    # locations:
    can :create, Location
    can :index_mine_changed, Location
    
    can :read, Location do |location|
      location.users.each do |associated_user|
        return true if associated_user == user
      end
      
      false
    end
    
    can [:update, :destroy], Location do |location|
      location.try(:creator) == user
    end
  end
end
