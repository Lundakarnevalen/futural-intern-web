class TicketListingsController < ApplicationController
  authorize_resource

  def index
    @listings = filter_query params
  end

  def show
    @listing = TicketListing.find params[:id]
  end

  def new
    @listing = TicketListing.new
  end

  def create
    @listing = TicketListing.create ticket_listing_params
    handle_errors @listing, 'Annons skapades utan problem'
  end

  private 
  def ticket_listing_params
    params.require(:ticket_listing).permit!
  end

  def filter_query query
    query = query.select do |k, _|
      [ :event_id, :selling ]
        .include? k
    end

    @query = query

    ar_query = TicketListing.includes(:event, :seller).order('price asc')

    if query[:event_id]
      ar_query = ar_query.where 'event_id = ?', query[:event_id]
    end

    if query[:selling]
      ar_query = ar_query.where 'sellings = ?', query[:selling]
    end

    return ar_query
  end
end
