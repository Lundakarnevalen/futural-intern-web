class PhotosController < ApplicationController
  authorize_resource
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

  def delete
  end

  private
    def photo_params
      params.require(:photo).permit!
    end

end
