class Api::PhonesController < ActionController::Base

  def create
    @phone = Phone.create(phone_params)
    return render failure if @phone.errors.any?
    render json: { status: :success, id: @phone.id }
  end

  private
    def failure
      render json: { status: :failure, message: @phone.errors.full_message.join('; ') }
    end
    def phone_params
      params.require(:phone).permit!
    end
end
