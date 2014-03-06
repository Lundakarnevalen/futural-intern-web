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

    # Can edit own details
    can [:show, :edit, :update], Karnevalist, :user_id => user.id

    # Karnevalist
    can [:create, :step1, :step1_post], Karnevalist
    can [:update, :step2, :enter_pwd, :step3, :step3_put, :step4], Karnevalist, :user_id => user.id

    # Notification
    can :read, Notification

    # Phone
    can [:create, :read, :update, :destroy], Phone

    # Checkout
    if user.is? :utcheckare
      can [:checkout, :checkout_digital, :checkout_digital_put, :checkout_paper, :checkout_paper_post], Karnevalist
    end

    # Sektionsadmin
    if user.is? :sektionsadmin
      can [:pusseldagen, :search, :search_filter_pusseldag, :show_modal, :index], Karnevalist
      if (k = user.karnevalist)
        can [:read], Karnevalist, :tilldelad_sektion => k.sektion.id
        can [:read, :export], Sektion, :id => k.sektion.id
      end
    end

    # Admin
    if user.is? :admin
      can :manage, :all
    end
  end
end
