class PhonesController < ApplicationController
  def new
    @phone = Phone.new
    @method = :post
    render :new
  end

  def create
    phone = Phone.create params[:phone]
    respond_to do |format|
      format.json do
        render :json =>
          if phone.errors.any?
            { :status => :failure,
              :message => phone.errors.full_messages.join('; ') }
          else
            { :status => :success,
              :id => phone.id }
          end
      end
    end
  end

  def update
    phone = Phone.find params[:id]
    phone.save
    respond_to do |format|
      format.json do
        render :json =>
          if phone.errors.any?
            { :status => :failure,
              :message => phone.errors.full_messages.join('; ') }
          else
            { :status => :success }
          end
      end
    end
  end

  def delete
    Phone.delete params[:id]
    respond_to do |format|
      format.json do
        render :json =>
          { :status => :success }
      end
    end
  end
end
