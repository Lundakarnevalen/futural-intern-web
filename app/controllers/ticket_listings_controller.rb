class TicketListingsController < ApplicationController
  authorize_resource

  def index
    @listings = filter_query params
  end

  def new
  end

  def create
    render text: params[:listing].inspect
  end

  private 
  def filter_query query
    query = query.select do |k, _|
      [ :event_id, :selling ]
        .include? k
    end

    @query = query

    ar_query = TicketListing.includes(:event, :karnevalist).order('price asc')

    if query[:event_id]
      ar_query = ar_query.where 'event_id = ?', query[:event_id]
    end

    if query[:selling]
      ar_query = ar_query.where 'sellings = ?', query[:selling]
    end

    return ar_query
  end
end
