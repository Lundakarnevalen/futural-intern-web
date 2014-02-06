# encoding: utf-8
class KarnevalisterController < ApplicationController
  require 'gcm'

  before_filter :authenticate_user_from_token!, :except => [:step1, :step1_post]
  before_filter :authenticate_user!, :except => [:step1, :step1_post]

  before_filter :returning_karnevalist, :only => :step1

  def index
    @karnevalister = Karnevalist.all.order("efternamn ASC")
    respond_to do |format|
      format.html{ render }
      format.json do
        render :json =>
          { :status => :success,
            :records => @karnevalister.length,
            :remaining => false,
            :karnevalister => @karnevalister }
      end
    end
  end

  def show
    @karnevalist = Karnevalist.find params[:id]
    put_base
    respond_to do |format|
      format.html{ render :edit }
      format.json do
        render :json =>
          { :status => :success,
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
    render :new
  end

  def create
    karnevalist = Karnevalist.create params[:karnevalist]
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
    karnevalist = Karnevalist.find params[:id]
    karnevalist.update_if_password_valid params[:karnevalist]
    karnevalist.save
    respond_to do |format|
      format.html{ redirect_to karnevalist }
      format.json do
        render :json =>
          if karnevalist.errors.any?
            { :status => :failure,
              :message => karnevalist.errors.full_messages.join('; ') }
          else
            { :status => :success }
          end
      end
    end
    if !karnevalist.google_token.blank?
      api_key = "AIzaSyCLMSbP2XW1dChD90iRXNbvdmHC9B7zavI"
      gcm = GCM.new(api_key)
      registration_id = Array.new
      registration_id.push karnevalist.google_token
      options = {
        'data' => {
          'message_type' => '1'
        }
      }
      @response = gcm.send_notification(registration_id, options)  # Tells Android app that user should be updated.
    end
  end

  def delete
    Karnevalist.delete params[:id]
    respond_to do |format|
      format.html { redirect_to Karnevalist }
      format.json do
        render :json =>
          { :status => :success }
      end
    end
  end

  def search
    @results = Karnevalist.search params[:q]
    respond_to do |format|
      format.html do
        if @results.length == 1
          @karnevalist = @results[0]
          put_base
          if URI(request.referer).path == '/karnevalister/checkout'
            redirect_to action: 'checkout_digital', id: @karnevalist.id
          else
            redirect_to action: 'edit', id: @karnevalist.id
          end
        else
          @karnevalister = @results.order("efternamn ASC")
          if URI(request.referer).path == '/karnevalister/checkout'
            redirect_to action: 'checkout', q: params[:q]
          else
            render :index
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
    if params[:stjarnmarkerad_sektion] == 'all'
      @filter2 = @filter1
    else
      if params[:stjarnmarkerad_sektion] == 'null'
        @filter2 = @filter1.where("snalla_sektion IS NULL")
      else
        @filter2 = @filter1.where("snalla_sektion = ?", params[:stjarnmarkerad_sektion])
      end
    end
    if params[:stjarnmarkerad_funktion] == 'all'
      @filter3 = @filter2
    else
      if params[:stjarnmarkerad_funktion] == 'null'
        @filter3 = @filter2.where("snalla_intresse IS NULL")
      else
        @filter3 = @filter2.where("snalla_intresse = ?", params[:stjarnmarkerad_funktion])
      end
    end
    @karnevalister = @filter3.order("efternamn ASC")
    render :uppdelning
  end


  # Stuff for apps.

  def step1
    @karnevalist = Karnevalist.new
    post_base
    render :step1
  end

  def step1_post
    @karnevalist = Karnevalist.create params[:karnevalist]

    sign_in(@karnevalist.user)
    cookies[:karnevalist_id] = { value: @karnevalist.id, expires: 7.days.from_now }

    redirect_to action: 'step2', id: @karnevalist.id
  end

  def step2
    @karnevalist = Karnevalist.find params[:id]
    post_base
    render :step2
  end

  def enter_pwd
    @karnevalist = Karnevalist.find params[:id]
    put_base
    if (params[:password] == "futural")
      @karnevalist.avklarat_steg = 2
      @karnevalist.save
      redirect_to step3_karnevalist_path(@karnevalist)
    else
      flash[:notice] = 'Fel lösenord. Du får veta vad lösenordet är när du kommer till Stora Salen i AF-borgen.'
      redirect_to action: 'step2', id: @karnevalist.id
    end
  end

  def step3
    @karnevalist = Karnevalist.find params[:id]

    if (@karnevalist.avklarat_steg < 2)
      redirect_to step2_karnevalist_path(@karnevalist)
    else
      put_base
      render :step3
    end
  end

  def step3_put
    @karnevalist = Karnevalist.find params[:id]
    @karnevalist.update_if_password_valid params[:karnevalist]
    @karnevalist.save
    redirect_to step4_karnevalist_path(@karnevalist)
  end

  def step4
    @karnevalist = Karnevalist.find params[:id]
    put_base
    render :step4
  end

  def checkout
    @id = params[:id]
    if !params[:q].blank?
      @karnevalister = Karnevalist.search params[:q]
    end
  end

  def checkout_paper
    @karnevalist = Karnevalist.new
    @method = :post
    render :checkout_paper
  end

  def checkout_paper_post
    @karnevalist = Karnevalist.create params[:karnevalist]

    @karnevalist.utcheckad = true
    @karnevalist.save

    redirect_to action: 'checkout', id: @karnevalist.id
  end

  def checkout_digital
    @karnevalist = Karnevalist.find params[:id]
    put_base
    render :checkout_digital
  end

  def checkout_digital_put
    @karnevalist = Karnevalist.find params[:id]
    @karnevalist.update_if_password_valid params[:karnevalist]

    @karnevalist.reload
    @karnevalist.utcheckad = true

    if @karnevalist.save && !@karnevalist.google_token.blank?
      api_key = "AIzaSyCLMSbP2XW1dChD90iRXNbvdmHC9B7zavI"
      gcm = GCM.new(api_key)
      registration_id = Array.new
      registration_id.push @karnevalist.google_token
      options = {
        'data' => {
          'title' => 'Utcheckad!',
          'message' => 'Nu är du utcheckad och klar, så nu kan du gå hem och sova.',
          'message_type' => '0',
          'utcheckad_at' => @karnevalist.utcheckad_at.strftime("%Y-%m-%d %H:%M")
        }
      }
      @response = gcm.send_notification(registration_id, options)
    end
    redirect_to action: 'checkout', id: @karnevalist.id
  end

  def uppdelning
  end

  def show_modal
    @karnevalist = Karnevalist.find params[:id]
    put_base
  end

  def put_base
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :put
  end

  def post_base
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :post
  end

  def returning_karnevalist
    if !cookies[:karnevalist_id].nil?
      @karnevalist = Karnevalist.find cookies[:karnevalist_id]

      if @karnevalist.nil?
        return
      end

      if @karnevalist.avklarat_steg == 1
        redirect_to action: 'step2', id: cookies[:karnevalist_id]
      elsif @karnevalist.avklarat_steg == 2
        redirect_to action: 'step3', id: cookies[:karnevalist_id]
      elsif @karnevalist.avklarat_steg == 3
        # Karnevalist utcheckad och kan inte redigeras
      end
    end
  end
end
