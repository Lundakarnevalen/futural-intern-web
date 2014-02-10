# encoding: utf-8
class KarnevalisterController < ApplicationController
  require 'gcm'

  before_filter :authenticate_user_from_token!, :except => [:create, :step1, :step1_post]
  before_filter :authenticate_user!, :except => [:create, :step1, :step1_post]

  load_and_authorize_resource

  before_filter :returning_karnevalist, :only => [:step1, :edit, :new, :step2, :step3, :step4]
  before_filter :stop_utcheckad, :only => [:update, :step3_put]
  before_filter :new_karnevalist, :only => [:step1, :step1_post]

  def index
    @karnevalister = nil
    respond_to do |format|
      format.html{ render }
      format.json do
        @karnevalister = Karnevalist.all.order("efternamn ASC")
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
      format.html do
        if current_user.is? :admin
          @karnevalist = Karnevalist.find params[:id]
          render :edit
        elsif user_signed_in?
          returning_karnevalist
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
    karnevalist.update_attributes! params[:karnevalist]
    karnevalist.save
    respond_to do |format|
      format.html{ redirect_to karnevalist }
      format.json do
        render :json =>
          if karnevalist.errors.any?
            { :status => :failure,
              :message => karnevalist.errors.full_messages.join('; ') }
          else
            { :status => :success,
              :token => karnevalist.user.authentication_token }
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
        @filter2 = @filter1.joins(:sektioner).where('sektion_id = ? OR snalla_sektion = ?', params[:sektion], params[:sektion])
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
        @filter3 = @filter2.joins(:intressen).where('intresse_id = ? OR snalla_intresse = ?', params[:funktion], params[:funktion])
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
    @karnevalister = @filter5.order("efternamn ASC")
    render :uppdelning
  end


  # Stuff for apps.

  def step1
    post_base
    render :step1
  end

  def step1_post
    @karnevalist.attributes = params[:karnevalist]

    if @karnevalist.save
      sign_in @karnevalist.user
      redirect_to action: 'step2', id: @karnevalist.id
    else
      render :action => :step1
    end
  end

  def step2
    @karnevalist = Karnevalist.find params[:id]
    post_base
    render :step2
  end

  def enter_pwd
    @karnevalist = Karnevalist.find params[:id]
    put_base
    if (params[:password].downcase == "futural")
      @karnevalist.avklarat_steg = 1
      @karnevalist.save
      redirect_to step3_karnevalist_path(@karnevalist)
    else
      flash[:notice] = 'Fel lösenord. Du får veta vad lösenordet är när du kommer till Stora Salen i AF-borgen.'
      redirect_to action: 'step2', id: @karnevalist.id
    end
  end

  def step3
    @karnevalist = Karnevalist.find params[:id]
    put_base
    render :step3
  end

  def step3_put
    @karnevalist = Karnevalist.find params[:id]
    @karnevalist.update_attributes! params[:karnevalist]
    @karnevalist.avklarat_steg = 2
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
    else
      @karnevalister = nil
    end
    imin = Karnevalist.where('utcheckad_at > ?', 10.minute.ago).count
    tot = Karnevalist.where('avklarat_steg < 3').count
    unless imin == 0
      t = ((tot/imin) * 10).minutes.from_now.strftime '%H:%M'
      flash[:onlynotice] = "Bra jobbat! Fortsätter du i det här tempot är vi klara klockan #{t}"
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

    if @karnevalist.errors.any?
      flash[:fuckedup] = 'Karnevalisten finns redan registrerad digitalt! Gör digital utcheckning.'
      redirect_to :action => :checkout
    else
      redirect_to action: 'checkout', id: @karnevalist.id
    end
  end

  def checkout_digital
    @karnevalist = Karnevalist.find params[:id]
    put_base
    render :checkout_digital
  end

  def checkout_digital_put
    @karnevalist = Karnevalist.find params[:id]
    @karnevalist.update_attributes! params[:karnevalist]

    @karnevalist.reload
    @karnevalist.utcheckad = true

    if @karnevalist.save && !@karnevalist.google_token.blank?
      api_key = "AIzaSyCLMSbP2XW1dChD90iRXNbvdmHC9B7zavI"
      gcm = GCM.new(api_key)
      registration_id = Array.new
      registration_id.push @karnevalist.google_token
      options1 = {
        'data' => {
          'id' => '1337',
          'title' => 'Utcheckad!',
          'message' => 'Nu är du utcheckad och klar, så nu kan du gå hem och sova.',
          'message_type' => '0',
          'created_at' => @karnevalist.utcheckad_at.strftime("%Y-%m-%d %H:%M")
        }
      }
      options2 = {
        'data' => {
          'message_type' => '1'
        }
      }
      @response1 = gcm.send_notification(registration_id, options1)
      @response2 = gcm.send_notification(registration_id, options2)
    end
    redirect_to action: 'checkout', id: @karnevalist.id
  end

  def uppdelning
    @karnevalister = nil
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
    if not user_signed_in?
      return false
    end

    if not params[:id].blank? and current_user.is? :admin
      @karnevalist = Karnevalist.find params[:id]
    else
      @karnevalist = Karnevalist.find_by_user_id current_user.id
    end

    if @karnevalist.nil?
      return false
    end

    if @karnevalist.avklarat_steg == 0
      redirect_to action: 'step2', id: @karnevalist.id unless action_name == 'step2'
    elsif @karnevalist.avklarat_steg == 1
      redirect_to action: 'step3', id: @karnevalist.id unless action_name == 'step3'
    elsif @karnevalist.avklarat_steg == 2
      redirect_to action: 'step4', id: @karnevalist.id unless action_name == 'step4' or action_name == 'step3'
    elsif @karnevalist.utcheckad
      redirect_to action: 'step4', id: @karnevalist.id unless action_name == 'step4'
    end
  end

  def stop_utcheckad
    karnevalist = Karnevalist.find params[:id]
    if not karnevalist.nil? and karnevalist.utcheckad and karnevalist.user == current_user
      karnevalist.errors.add :base, "Du får tyvärr inte ändra något efter att du checkat ut."
      respond_to do |format|
        format.html{ redirect_to karnevalist }
        format.json do
          render :json =>
            { :status => :failure,
              :message => karnevalist.errors.full_messages.join('; ') }
        end
      end
    end
  end

  def new_karnevalist
    @karnevalist = Karnevalist.new
  end
end
