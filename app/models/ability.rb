class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    admin = user.roles.find_by_name "admin"
    if !admin.nil?
      can :manage, :all
    end

    # Has account
    can [:step2, :enter_pwd, :step3, :step3_put, :step4, :update, :show], Karnevalist, :user_id => user.id
    # Create account
    can [:create, :step1, :step1_post], Karnevalist

    can :read, Notification

    can [:create, :read, :update, :destroy], Phone
  end
end
