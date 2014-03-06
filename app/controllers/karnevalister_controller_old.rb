# encoding: utf-8

class KarnevalisterController < ApplicationController
  # Old stuff that is not maintained.

  before_filter :returning_karnevalist, :only => [:step1, :step2, :step3, :step4]
  before_filter :stop_utcheckad, :only => [:update, :step3_put]

  def returning_karnevalist
    if not user_signed_in?
      return false
    end

    if not params[:id].blank?
      @karnevalist = Karnevalist.find params[:id]
    else
      @karnevalist = Karnevalist.find_by_user_id current_user.id
    end

    if not current_user.can? :read, @karnevalist
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

  def step1
    @karnevalist = Karnevalist.new
    post_base
    render :step1
  end

  def step1_post
    @karnevalist = Karnevalist.new
    @karnevalist.attributes = karnevalist_params

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
    @karnevalist.update_attributes! karnevalist_params
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
    @karnevalist = Karnevalist.create karnevalist_params

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
    @karnevalist.update_attributes! karnevalist_params

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

  def stop_utcheckad
    karnevalist = Karnevalist.find params[:id]
    if not karnevalist.nil? and karnevalist.utcheckad and not current_user.is? :admin and not current_user.is? :sektionsadmin
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
end
