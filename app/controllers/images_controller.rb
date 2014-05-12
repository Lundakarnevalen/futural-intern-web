class ImagesController < ApplicationController
  authorize_resource

  def new
    @image = Image.new(sektion_id: params[:sektion_id])
  end

  def create
    @image = Image.new(params[:image])
    authorize_sektion @image
    @image.save
    handle_errors @image, 'Filen sparades!', :redirect => images_sektion_path(@image.sektion)
  end

  def show
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find(params[:id])
    sektion = @image.sektion
    @image.destroy
    flash[:notice] = "Raderade filen =("
    redirect_to images_sektion_path(sektion)
  end

  def authorize_sektion image
    if image.sektion.nil? || ! current_sektioner.include?(image.sektion)
      authorize! :modify, Image.new
    end
  end

  private

  def image_params
    params.require(:image).permit!
  end
end
