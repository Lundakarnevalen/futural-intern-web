class TicketListingsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :destroy ]
  authorize_resource, :except => [ :destroy ]

  def index
    @listings = filter_query params
  end

  def show
    @listing = TicketListing.find params[:id]
  end

  def new
    @listing = TicketListing.new
  end

  def edit
    @listing = TicketListing.find params[:id]
  end

  def create
    @listing = TicketListing.new ticket_listing_params
    @listing.seller = current_karnevalist
    @listing.save
    handle_errors @listing, 'Annons skapades utan problem'
  end

  def update
    @listing = TicketListing.find params[:id]
    @listing.update_attributes ticket_listing_params
    handle_errors @listing, 'Annons ändrades utan problem'
  end

  def destroy
    @listing = TicketListing.find params[:id]

    unless params[:token] == @listing.access_token
      authenticate_user!
      authorize! :destroy, @listing
    end

    @listing.destroy
    handle_errors @listing, 'Annons togs bort utan problem'
  end

  private 
  def ticket_listing_params
    params.require(:ticket_listing).permit!
  end

  def filter_query params
    query = params.symbolize_keys.select do |k, v|
      [ :event_id, :seller_id, :selling ]
        .include?(k) && v.present?
    end

    @query = query

    ar_query = TicketListing.includes(:event, :seller).order('price asc')

    if query[:event_id]
      ar_query = ar_query.where 'event_id = ?', query[:event_id]
    end

    if query[:seller_id]
      ar_query = ar_query.where 'seller_id = ?', query[:seller_id]
    end

    if query[:selling]
      ar_query = ar_query.where 'selling = ?', query[:selling]
    end

    return ar_query
  end
end