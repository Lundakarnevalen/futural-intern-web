class SektionerController < ApplicationController
  load_and_authorize_resource

  def export
    @sektion = Sektion.find params[:id]
    render :xlsx => 'export',
           :filename => "#{@sektion.name.downcase}-#{Time.now.strftime '%Y%m%d'}.xlsx",
           :disposition => 'attachment'
  end
end
