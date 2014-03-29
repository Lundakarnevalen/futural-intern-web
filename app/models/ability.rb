
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

    # Karnevalist
    can [:create, :new, :step1, :step1_post], Karnevalist
    can [:read, :step2, :enter_pwd, :step3, :step3_put, :step4], Karnevalist, :user_id => user.id

    # Notification
    can :read, Notification

    # Phone
    can [:create, :read, :update, :destroy], Phone

    # Checkout
    if user.is? :utcheckare
      can [:checkout, :checkout_digital, :checkout_digital_put, :checkout_paper, :checkout_paper_post], Karnevalist
    end

    # Check karnevalist
    if user.is? :checker
      can :check, Karnevalist
    end

    # Export
    if user.is? :exporter
      can :export_all, Karnevalist
    end

    # Sektionsadmin
    if user.is? :sektionsadmin
      can [:pusseldagen, :search, :search_filter_pusseldag, :show_modal, :index], Karnevalist
      if user.karnevalist?
        can [:read, :edit, :update], Karnevalist, :tilldelad_sektion => user.sektioner
        can [:read, :edit, :update], Karnevalist, :tilldelad_sektion2 => user.sektioner
        can [:read, :edit, :create, :destroy], Post
        can [:manage], Sektion, :id => user.sektioner
      end
    end

    # Admin
    if user.is? :admin
      can :manage, :all
    end
  end
end
