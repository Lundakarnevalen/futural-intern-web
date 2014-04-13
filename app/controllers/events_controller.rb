class EventsController < ApplicationController
  authorize_resource

  # Views
  def index
    @events = Event.upcoming.for_sektioner current_sektioner
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    @event = Event.new :sektion_id => current_sektioner.first
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

  def authorize_sektion ev
    if ev.sektion.nil? || ev.sektion != sektion_or_nil
      authorize! :modify, Event.new
    end
  end

  private
  def event_params
    params.require(:event).permit!
  end
end
