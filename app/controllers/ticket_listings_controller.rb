class TicketListingsController < ApplicationController
  # Bypass the many layers of filtering when auth by token
  authorize_resource
  skip_authorization_check :only => [ :destroy ]
  skip_before_filter :require_login, :only => :destroy
  skip_before_filter :can_can_strong, :only => :destroy

  def index
    @listings = TicketListing.where(nil)
    filtering_params(params).each do |key, value|
      @listings = @listings.public_send(key, value) if value.present?
    end
    @events = TicketListing.ticket_events_for_karnevalist(current_karnevalist)
  end

  def show
    @listing = TicketListing.find params[:id]
  end

  def new
    @listing = TicketListing.new
    @events = TicketListing.ticket_events_for_karnevalist(current_karnevalist)
  end

  def edit
    @listing = TicketListing.find params[:id]
    @events = TicketListing.ticket_events_for_karnevalist(current_karnevalist)
    @selected = @listing.event_id
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

  def offer
    # Very naive spam protection...
    if session[:karneblocket_offers] &&
       session[:karneblocket_offers].include?(params[:id])
      flash[:alert] = 'Inte spamma!'
      redirect_to :back
    elsif params[:message].empty?
      flash[:alert] = 'Du angav inget meddelande'
      redirect_to :back
    else
      session[:karneblocket_offers] ||= []
      session[:karneblocket_offers] << params[:id]

      @listing = TicketListing.find params[:id]
      KarneblocketMailer.offer(@listing, params[:message],
                               current_karnevalist).deliver
      flash[:notice] = 'Ett mail skickades till säljaren med ditt meddelade'
      redirect_to :back
    end
  end

  private
  def ticket_listing_params
    params.require(:ticket_listing).permit!
  end

  def filtering_params params
    params.slice(:event_id, :seller_id, :selling)
  end
end
