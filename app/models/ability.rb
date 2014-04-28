# -*- encoding : utf-8 -*-
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
    can [:read], Post
    can [:read, :sign_up, :attend], Event
    can [:read, :show_english, :show_contact], Sektion

    can :read, Notification, :recipient_id => 0

    # Notification
    if user.karnevalist?
      can :read, Notification, :recipient_id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}.push(0)
    end

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

    # Sektion-local info
    if user.is?(:info) && user.karnevalist.present? && user.karnevalist.sektion.present?
      can :manage, Post, :sektion_id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
      can :manage, Event, :sektion_id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
      can [:create, :update], Notification, :recipient_id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
      can :new, Notification
      can [:update, :edit_info, :edit_contact, :edit_english], Sektion, :id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
    end

    # Global info
    if user.is? :'global-info'
      can :manage, Post
      can :manage, Event
    end

    # Sektionsadmin
    if user.is? :sektionsadmin
      can [:pusseldagen, :search, :search_filter_pusseldag, :show_modal, :index], Karnevalist
      if user.karnevalist?
        can [:read, :edit, :update], Karnevalist, :tilldelad_sektion => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
        can [:read, :edit, :update], Karnevalist, :tilldelad_sektion2 => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
        can [:manage], Sektion, :id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
      end
    end

    # Sektionsadmin Lite
    if user.is? :sektionsadmin_lite
      if user.karnevalist?
        can [:edit, :update], Karnevalist, :tilldelad_sektion => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
        can [:edit, :update], Karnevalist, :tilldelad_sektion2 => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
        can [:read, :aktiva], Sektion, :id => user.karnevalist.tilldelade_sektioner.map{|s| s.id}
      end
    end

    # Lagersystem - admin
    if (user.is? :admin_fabriken) || (user.is? :admin_festmasteriet) || (user.is? :admin_snaxeriet)
      can :manage, Order
      can :manage, Product
      can :manage, IncomingDelivery
      can :manage, PartialDelivery
      can :manage, ProductCategory
      can :manage, Reservation
      can :manage, Backorder
    end

    # Lagersystem - beställare
    if (user.is? :bestallare_fabriken) || (user.is? :bestallare_festmasteriet) || (user.is? :bestallare_snaxeriet)
      can [:create, :read, :update, :confirm, :confirm_put], Order, :karnevalist_id => user.karnevalist.id
      can :read, Product
      can :read, PartialDelivery
      can :read, Reservation
      can [:create, :read], Backorder
      can [:create, :update, :destroy], Reservation, :karnevalist_id => user.karnevalist.id
    end

    # Lagersystem - sektionsadmin
    if (user.is? :sektionsadmin_fabriken) || (user.is? :sektionsadmin_festmasteriet)
      # Show "Tåget - Vagn" instead of "Tåget - centralt"
      if user.karnevalist.tilldelad_sektion == 399
        sektion_id = 300
      else
        sektion_id = user.karnevalist.tilldelad_sektion
      end
      can [:sektion, :read], Order, :sektion_id => sektion_id
    end

    # Lagersystem - kassör
    if user.is? :kassor_festmasteriet
      can :manage, Order
      can [:read, :weekly_overview], Product
      can :manage, IncomingDelivery
      can :manage, PartialDelivery
      can :manage, ProductCategory
      can :manage, Reservation
      can :manage, Backorder
    end

    if user.is?(:admin) || user.is?(:photographer)
      can [:read, :update, :delete], Photo
    end

    # Access admin
    if user.is? :'access-admin'
      can :manage, Role
    end

    # Admin
    if user.is? :admin
      can :manage, :all
    end
  end
end
