class TicketListingsController < ApplicationController
  # Bypass the many layers of filtering when auth by token
  authorize_resource
  skip_authorization_check :only => [ :destroy ]
  skip_before_filter :require_login, :only => :destroy
  skip_before_filter :can_can_strong, :only => :destroy

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

    if params[:token] == @listing.access_token
      @listing.destroy
      render :text => (@listing.errors.any?? @listing.errors.full_messages.join('; ')
                                           : '<strong>Annonsen togs bort!<strong>')
    else
      authorize! :destroy, @listing
      @listing.destroy
      handle_errors @listing, 'Annons togs bort utan problem'
    end
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
