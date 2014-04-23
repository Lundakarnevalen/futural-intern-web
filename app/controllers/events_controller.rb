# -*- encoding : utf-8 -*-
class EventsController < ApplicationController
  authorize_resource

  # Views
  def index
    if (current_user.is? :'global-info') || (current_user.is? :admin)
      @events = Event.upcoming
    else
      @events = Event.upcoming.for_sektioner current_sektioner
    end
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    @event = Event.new :sektion_id => current_sektioner.first.id
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

  # Attendance

  def attending
    @event = Event.includes(:attendances => :karnevalist)
                  .order('karnevalister.efternamn, karnevalister.fornamn')
                  .find params[:id]
    authorize! :modify, @event
  end

  def sign_up
    @event = Event.find params[:id]
    @attendance = Attendance.existing_or_new :event => @event,
                                             :karnevalist => current_karnevalist
  end

  def attend
    @event = Event.find params[:id]
    aps = attendance_params.merge({ :event => @event,
                                    :karnevalist => current_karnevalist })
    a = Attendance.create_or_update aps
    handle_errors a, 'Du är anmäld!', :redirect => @event
  end

  # Utility

  def authorize_sektion ev
    if ev.sektion.nil? || ! current_sektioner.include?(ev.sektion)
      authorize! :modify, Event.new
    end
  end

  private
  def event_params
    params.require(:event).permit!
  end

  def attendance_params
    params.require(:attendance).permit :comment
  end
end
