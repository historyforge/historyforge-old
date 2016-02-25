class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.new_record?
      can :read, Map do |map|
        map.status == :published
      end
      can :read, Building
      can :read, Architect
    else
      if user.has_role?("administrator") || user.has_role?("super user")
        can :manage, :all
      elsif user.has_role?("editor")
        can :manage, Layer
        can :manage, Map
        can :manage, Gcp
        can :manage, Building
        can :manage, Architect
      end

      can :manage, Layer, user_id: user.id
      can :update, User, id: user.id
    end
  end
end
