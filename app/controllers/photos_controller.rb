class PhotosController < ApplicationController
  authorize_resource
  def index
    @photos = Photo.where(accepted: false).to_a
    respond_to do |format|
      format.html
      format.json { render json: @photos }
    end
  end

  def update
  end

  def delete
  end

end
