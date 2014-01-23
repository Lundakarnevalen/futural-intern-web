class KarnevalisterController < ApplicationController
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

  alias :edit :show

  # HTML only
  def new
    @karnevalist = Karnevalist.new
    @intresse_ids = @karnevalist.intresse_ids
    @sektion_ids = @karnevalist.sektion_ids
    @method = :post
    render :edit
  end

  def create
    karnevalist = Karnevalist.create params[:karnevalist]
    respond_to do |format|
      format.html{ redirect_to karnevalist }
      format.json do
        render :json => 
          if karnevalist.errors.any?
            { :status => :failure,
              :message => karnevalist.errors.full_messages }
          else
            { :status => :success,
              :id => karnevalist.id,
              :token => '#yoloswag' }
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
              :message => karnevalist.errors.full_messages }
          else
            { :status => :success,
              :token => '#yoloswag' }
          end
      end
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
end
