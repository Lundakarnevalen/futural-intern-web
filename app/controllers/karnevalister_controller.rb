# encoding: utf-8
class KarnevalisterController < ApplicationController
  require 'gcm'

  def index
    @karnevalister = Karnevalist.all
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
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :put
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
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :post
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
              :token => karnevalist.password }
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
    @karnevalister = Karnevalist.search params[:q]
    respond_to do |format|
      format.html{ render :index }
      format.json do
        render :json =>
          { :status => :success,
            :records => @karnevalister.length,
            :remaining => false,
            :karnevalister => @karnevalister }
      end
    end
  end

  # Stuff for apps.

  def step1
    @karnevalist = Karnevalist.new
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :post
    render :step1
  end

  def step1_post
    @karnevalist = Karnevalist.create params[:karnevalist]
    redirect_to action: 'step2', id: @karnevalist.id
  end

  def step2
    @karnevalist = Karnevalist.find params[:id]
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :post
    render :step2
  end

  def enter_pwd
    @karnevalist = Karnevalist.find params[:id]
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    if (params[:password] == "futural")
      redirect_to step3_karnevalist_path(@karnevalist)
    else
      render text: params[:password]
    end
  end

  def step3
    @karnevalist = Karnevalist.find params[:id]
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :put
    render :step3
  end

  def step3_put
    @karnevalist = Karnevalist.find params[:id]
    @karnevalist.update_if_password_valid params[:karnevalist]
    @karnevalist.save
    redirect_to step4_karnevalist_path(@karnevalist)
  end

  def step4
    @karnevalist = Karnevalist.find params[:id]
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    render :step4
  end

  def checkout
    @id = params[:id]
  end

  def checkout_paper
    @karnevalist = Karnevalist.new
    @method = :post
    render :checkout_paper
  end

  def checkout_paper_post
    @karnevalist = Karnevalist.create params[:karnevalist]
    redirect_to action: 'checkout', id: @karnevalist.id
  end

  def checkout_digital
    @karnevalist = Karnevalist.find params[:id]
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :put
    render :checkout_digital
  end

  def checkout_digital_put
    @karnevalist = Karnevalist.find params[:id]
    @karnevalist.update_if_password_valid params[:karnevalist]
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
end
