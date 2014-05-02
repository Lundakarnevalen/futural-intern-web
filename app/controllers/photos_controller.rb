class PhotosController < ApplicationController
  authorize_resource
  before_filter :find_photo, only: [:update, :destroy]
  def index
    @photos = Photo.where(accepted: true).to_a
  end

  def white_list
    @photos = Photo.where(accepted: false).to_a
    respond_to do |format|
      format.html
      format.json { render json: @photos }
    end
  end

  def new
    @photo = Photo.new
  end

  def create
    pp = photo_params
    official = current_user.is?("photographer")
    pp.merge!(official: official, accepted: official)
    @photo = Photo.new(pp)
    if @photo.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    @photo = Photo.find(params[:id])
    @photo.update_attributes(params[:photo])
    respond_to do |format|
      if @photo.save
        format.json { render json: { success: true }, status: :ok }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.json { render json: { success: true }, status: :ok }
    end
  end

  private
    def find_photo
      @photo = Photo.find(params[:id])
    end
    def photo_params
      params.require(:photo).permit!
    end

end
