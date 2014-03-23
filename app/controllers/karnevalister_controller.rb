# encoding: utf-8

require 'karnevalister_controller_old'

class KarnevalisterController < ApplicationController
  require 'gcm'

  before_filter :authenticate_user_from_token!, :except => [:create, :new, :step1, :step1_post, :export_all]
  before_filter :authenticate_user!, :except => [:create, :new, :step1, :step1_post, :export_all]

  load_and_authorize_resource

  def index
    c = current_user

    if c.is? :admin
      @karnevalister = Karnevalist.order(efternamn: :asc, fornamn: :asc)
    elsif c.karnevalist? and c.is? :sektionsadmin
      @karnevalister = Karnevalist.where(:tilldelad_sektion => c.sektioner).order(efternamn: :asc, fornamn: :asc)
    else
      raise(CanCan::AccessDenied, 'Invalid access request')
    end

    render :layout => 'bare'
  end

  def show
    @karnevalist = Karnevalist.find params[:id]
    put_base
    respond_to do |format|
      format.html do
        if current_user.can? :edit, @karnevalist
          render :edit, :layout => 'bare'
        elsif user_signed_in?
          returning_karnevalist
        else
          redirect_to root_url
        end
      end
      format.json do
        render :json =>
          { :status => :success,
            :token => current_user.authentication_token,
            :karnevalist => @karnevalist }
      end
    end
  end

  def edit
    show
  end

  def new
    @karnevalist = Karnevalist.new
    post_base
    render :new, :layout => 'bare'
  end

  def create
    karnevalist = Karnevalist.create karnevalist_params

    if not karnevalist.errors.any?
      karnevalist.update_attribute :avklarat_steg, 2

      if not user_signed_in?
        sign_in karnevalist.user
      end
    end

    respond_to do |format|
      format.html{ redirect_to karnevalist }
      format.json do
        render :json =>
          if karnevalist.errors.any?
            { :status => :failure,
              :message => karnevalist.errors.full_messages.join('; ') }
          else
            { :status => :success,
              :id => karnevalist.id,
              :token => karnevalist.user.authentication_token }
          end
      end
    end
  end

  def update
    @karnevalist = Karnevalist.includes(:sektioner, :intressen)
                              .find(params[:id])
    put_base
    @karnevalist.attributes = karnevalist_params

    if @karnevalist.tilldelad_sektion_changed?
      # Fail unless got access.
      authorize! :change_sektion, @karnevalist
    end

    @karnevalist.save

    respond_to do |format|
      format.html { render :edit, :layout => 'bare' }
      format.json do
        render :json =>
          if @karnevalist.errors.any?
            { :status => :failure,
              :message => @karnevalist.errors.full_messages.join('; ') }
          else
            { :status => :success,
              :token => @karnevalist.user.authentication_token }
          end
      end
    end
    if !@karnevalist.google_token.blank?
      api_key = "AIzaSyCLMSbP2XW1dChD90iRXNbvdmHC9B7zavI"
      gcm = GCM.new(api_key)
      registration_id = Array.new
      registration_id.push @karnevalist.google_token
      options = {
        'data' => {
          'message_type' => '1'
        }
      }
      @response = gcm.send_notification(registration_id, options)  # Tells Android app that user should be updated.
    end
  end

  def destroy
    Karnevalist.destroy params[:id]
    flash[:notice] = 'Karnevalisten är eliminerad.'
    respond_to do |format|
      format.html { redirect_to Karnevalist }
      format.json do
        render :json =>
          { :status => :success }
      end
    end
  end

  def search
    if params[:q].present?
      @results = Karnevalist.search params[:q]
    else
      @results = []
    end

    if not request.referer.blank? and URI(request.referer).path == '/karnevalister/checkout'
      checkout = true
    else
      checkout = false
    end

    respond_to do |format|
      format.html do
        if @results.length == 1
          if not current_user.can? :read, @results[0]
            @karnevalister = []
            render :index, :layout => 'bare'
          else
            @karnevalist = @results[0]
            put_base
            if checkout
              redirect_to action: 'checkout_digital', id: @karnevalist.id
            else
              redirect_to action: 'show', id: @karnevalist.id
            end
          end
        else
          @results = @results.order("efternamn ASC")

          if current_user.is? :sektionsadmin
            @results = @results.where(:tilldelad_sektion => current_user.sektioner)
          end

          @karnevalister = @results

          if checkout
            redirect_to action: 'checkout', q: params[:q]
          else
            render :index, :layout => 'bare'
          end
        end
      end
      format.json do
        render :json =>
          { :status => :success,
            :records => @karnevalister.length,
            :remaining => false,
            :karnevalister => @karnevalister }
      end
    end
  end

  def search_filter
    @search = Karnevalist.search params[:q]
    @search = @search.where("avklarat_steg = ?", 3)
    if params[:tilldelad_sektion] == 'all'
      @filter1 = @search
    else
      if params[:tilldelad_sektion] == 'null'
        @filter1 = @search.where("tilldelad_sektion IS NULL")
      else
        @filter1 = @search.where("tilldelad_sektion = ?", params[:tilldelad_sektion])
      end
    end
    if params[:sektion] == 'all'
      if params[:stjarnmarkerad_sektion] == 'true'
        @filter2 = @filter1.where("snalla_sektion IS NOT NULL")
      else
        @filter2 = @filter1
      end
    else
      if params[:stjarnmarkerad_sektion] == 'true'
        @filter2 = @filter1.where("snalla_sektion = ?", params[:sektion])
      else
        @filter2 = @filter1.joins(:sektioner).group('karnevalister.id').where('sektion_id = ? OR snalla_sektion = ?', params[:sektion], params[:sektion])
      end
    end
    if params[:funktion] == 'all'
      if params[:stjarnmarkerad_funktion] == 'true'
        @filter3 = @filter2.where("snalla_intresse IS NOT NULL")
      else
        @filter3 = @filter2
      end
    else
      if params[:stjarnmarkerad_funktion] == 'true'
        @filter3 = @filter2.where("snalla_intresse = ?", params[:funktion])
      else
        @filter3 = @filter2.joins(:intressen).group('karnevalister.id').where('intresse_id = ? OR snalla_intresse = ?', params[:funktion], params[:funktion])
      end
    end
    if params[:tilldelad_klar] == 'all'
      @filter4 = @filter3
    else
      if params[:tilldelad_klar] == 'true'
        @filter4 = @filter3.where("tilldelad_klar = 1")
      else
        @filter4 = @filter3.where("tilldelad_klar = 0 OR tilldelad_klar IS NULL")
      end
    end
    if params[:vill_ansvara] == 'all'
      @filter5 = @filter4
    else
      if params[:vill_ansvara] == 'true'
        @filter5 = @filter4.where("vill_ansvara = 1")
      else
        @filter5 = @filter4.where("vill_ansvara = 0 OR vill_ansvara IS NULL")
      end
    end
    if params[:kon] == 'all'
      @filter6 = @filter5
    else
      @filter6 = @filter5.where("kon_id = ?", params[:kon])
    end
    @karnevalister = @filter6.group('karnevalister.id').order("efternamn ASC")
    render :uppdelning, :layout => 'bare'
  end

  def gealla
    @karnevalister = Karnevalist.where :id => params[:karnevalist_ids]
    @sektion = Sektion.find params[:sektion_id]
    @karnevalister.update_all :tilldelad_sektion => @sektion.id, 
                              :tilldelad_klar => true

    flash[:notice] = "Nu har #{@karnevalister.length} glada karnevalister fått vars en sektion. Det gick väl fort?"
    redirect_to :action => :uppdelning
  end

  def search_filter_pusseldag
    @search = Karnevalist.search params[:q]
    @search = @search.where("avklarat_steg = ?", 3)
    if params[:tilldelad_sektion] == 'all'
      @filter1 = @search
    else
      if params[:tilldelad_sektion] == 'null'
        @filter1 = @search.where("tilldelad_sektion IS NULL")
      else
        @filter1 = @search.where("tilldelad_sektion = ?", params[:tilldelad_sektion])
      end
    end
    if params[:funktion] == 'all'
      if params[:stjarnmarkerad_funktion] == 'true'
        @filter2 = @filter1.where("snalla_intresse IS NOT NULL")
      else
        @filter2 = @filter1
      end
    else
      if params[:stjarnmarkerad_funktion] == 'true'
        @filter2 = @filter1.where("snalla_intresse = ?", params[:funktion])
      else
        @filter2 = @filter1.joins(:intressen).group('karnevalister.id').where('intresse_id = ? OR snalla_intresse = ?', params[:funktion], params[:funktion])
      end
    end
    if params[:pusseldag_keep] == 'all'
      @filter3 = @filter2
    else
      if params[:pusseldag_keep] == 'true'
        @filter3 = @filter2.where("pusseldag_keep = 1")
      else
        @filter3 = @filter2.where("pusseldag_keep = 0 OR pusseldag_keep IS NULL")
      end
    end
    if params[:vill_ansvara] == 'all'
      @filter4 = @filter3
    else
      if params[:vill_ansvara] == 'true'
        @filter4 = @filter3.where("vill_ansvara = 1")
      else
        @filter4 = @filter3.where("vill_ansvara = 0 OR vill_ansvara IS NULL")
      end
    end
    if params[:kon] == 'all'
      @filter5 = @filter4
    else
      @filter5 = @filter4.where("kon_id = ?", params[:kon])
    end
    @karnevalister = @filter5.group('karnevalister.id').order("efternamn ASC")
    render :pusseldagen, :layout => 'bare'
  end

  def pusseldagen
    @karnevalister = Karnevalist.group("karnevalister.id").where("tilldelad_sektion = ?", current_user.karnevalist.tilldelad_sektion).order("efternamn ASC")
  end

  def export_all
    authorize! :export_all, Karnevalist
    @karnevalister = Karnevalist.includes([:sektion, :kon, :korkort, :storlek, :nation]).all
    render :xlsx => 'export_all',
           :filename => "karnevalister-#{Time.now.strftime '%Y%m%d'}.xlsx",
           :disposition => 'attachment'
  end

  private
  def karnevalist_params
    params.require(:karnevalist).permit!
  end
end
