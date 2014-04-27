class Api::PhotosController < Api::ApiController
  before_filter :authenticate_user_from_token!
  def index
    photos = Photo.where(accepted: true)
    render status: 200, json: { success: true, photos: photos}
  end

  def show
    @p = Photo.find(params[:id])
    render status: 200, json: { success: true, photo: @p }
  end

  def create
    p = photo_params
    p.merge!(karnevalist_id: current_user.karnevalist.id)
    @photo = Photo.new(p)
    render_response(@photo.save)
  end

  private
    def render_response(success)
      return render status: 400, json: { success: false, errors: @photo.errors.full_messages } unless success
      render status: 201, json: { success: true, photo: @photo }
    end

    def photo_params
      params.require(:photo).permit!
    end
end
