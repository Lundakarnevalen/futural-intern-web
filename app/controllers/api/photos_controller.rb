class Api::PhotosController < Api::ApiController
  before_filter :authenticate_user_from_token!

  def index
    photos = Photo.where(accepted: true).all
    render status: 200, json: { success: true, photos: photos}
  end

  def show
    @p = Photo.find(params[:id])
    render status: 200, json: { success: true, photo: @p }
  end

  def create
  end

  def update
  end

  def delete
  end

  private
    def photo_params
      params.require(:photo).permit!
    end
end
