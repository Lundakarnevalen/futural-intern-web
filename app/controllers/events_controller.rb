class EventsController < ApplicationController
  authorize_resource

  # Views
  def index
    @events = Event.upcoming.for_sektion sektion_or_nil
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    @event = Event.new :sektion_id => sektion_or_nil.id
  end

  def edit
    @event = Event.find params[:id]
  end

  # Modifiers
  def create
    @event = Event.new event_params
    @event.creator = current_user
    authorize_sektion @event
    @event.save
    handle_errors @event, 'Händelsen skapades'
  end

  def update
    @event = Event.find params[:id]
    authorize_sektion @event
    @event.update_attributes event_params
    handle_errors @event, 'Händelsen ändrades'
  end

  def destroy
    @event = Event.find params[:id]
    @event.destroy
    handle_errors @event, 'Händelsen togs bort', :redirect => Event
  end

  # Utility
  def handle_errors res, msg, opts = {}
    opts = { :redirect => res }.merge opts

    if res.errors.any?
      flash[:alert] = res.errors.full_messages.join '; '
      redirect_to :back
    else
      flash[:notice] = msg
      redirect_to opts[:redirect]
    end
  end

  def authorize_sektion ev
    if ev.sektion.nil? || ev.sektion != sektion_or_nil
      authorize! :modify, Event.new
    end
  end

  def sektion_or_nil
    if current_user.karnevalist.present?
      current_user.karnevalist.sektion
    end # else nil
  end

  private
  def event_params
    params.require(:event).permit!
  end
end
