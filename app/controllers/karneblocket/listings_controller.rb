# -*- encoding : utf-8 -*-
class Karneblocket::ListingsController < ApplicationController
  skip_before_filter :require_login

  skip_authorization_check
  def index
    if signed_in?
      #render :json => TicketListing::first()
      @listings = TicketListing.all
    else
      redirect_to new_user_session_path
    end
  end

  def new
  end

  def create
    @listing = TicketListing.new(params[:ticketlisting])
    @listing.seller = current_karnevalist
    @listing.save
    render :json => {
        :user => c,
        :listing => params[:listing],
        :listing_created => @listing.inspect
    }
    #render text: params.inspect + " Karnevalist: " + c.karnevalist.attributes.inspect + " Full user:" + c.attributes.inspect
  end
end
