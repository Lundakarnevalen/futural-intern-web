class SektionerController < ApplicationController
  load_and_authorize_resource

  def index
    @sektioner = Sektion.all.order 'name asc'
  end

  def show
    @sektion = Sektion.find params[:id]
  end

  def export
    @sektion = Sektion.find params[:id]
    render :xlsx => 'export',
           :filename => "#{@sektion.name.downcase}-#{Time.now.strftime '%Y%m%d'}.xlsx",
           :disposition => 'attachment'
  end
end
