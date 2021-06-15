class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.new_record?
      can :read, Building do |building| building.reviewed?; end
      can :read, Architect
      can :read, CensusRecord do |record| record.reviewed?; end
      can :read, Photograph do |record| record.reviewed?; end
    else
      can :update, User, id: user.id
      can :read, CensusRecord
      can :read, Building
      can :read, Photograph
      can :create, Flag
      can :read, Document

      if user.has_role?("administrator") || user.has_role?("super user")
        can :manage, :all
      elsif user.has_role?("editor")
        can :manage, :all
        cannot :bulk_update, :all
        cannot :manage, User
        # can :manage, Document
        # can :manage, DocumentCategory
        # can :manage, Building
        # can :manage, Architect
        # can :manage, CensusRecord
        # can :manage, Photograph
        # can :manage, Flag
        # can :manage, Person
        # can :manage, StreetConversion
      end

      if user.has_role?("census taker")
        can :create, CensusRecord
        can :update, CensusRecord, created_by_id: user.id
      end

      if user.has_role?("builder")
        can :create, Building
        can :update, Building, created_by_id: user.id
      end

    end
  end
end
