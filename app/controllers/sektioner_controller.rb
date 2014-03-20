class SektionerController < ApplicationController
  load_and_authorize_resource

  def index
    if current_user.is? :admin
      @sektioner = Sektion.all.order 'name asc'
    elsif current_user.is? :sektionsadmin
      @sektioner = Sektion.where(:id => current_user.sektioner).order 'name asc'
    end
  end

  def show
    @sektion = Sektion.find params[:id]
  end

  def export
    @sektion = Sektion.find params[:id]
    render :xlsx => 'export_all',
           :filename => "#{@sektion.name.downcase}-#{Time.now.strftime '%Y%m%d'}.xlsx",
           :disposition => 'attachment'
  end

  def kollamedlem
    @sektion = Sektion.find(params[:id])
    authorize! :read, @sektion
    @karnevalister = @sektion.members.order('efternamn, fornamn asc')
  end
end
