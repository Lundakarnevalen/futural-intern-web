# -*- encoding : utf-8 -*-
class SektionerController < ApplicationController
  load_and_authorize_resource

  def index
    @sektioner = Sektion.all.order 'name asc'
  end

  def show
    @sektion = Sektion.find params[:id]
    @page_content = @sektion.info_page
    if @page_content.blank?
      @page_content = "Snart kommer du kunna läsa information om din sektion här."
    end
  end

  def show_english
    @sektion = Sektion.find params[:id]
    @page_content = @sektion.english_page
    @page_content = "In English" if @page_content.blank?
  end

  def edit_english
    @sektion = Sektion.find params[:id]
  end

  def show_contact
    @sektion = Sektion.find params[:id]
    @page_content = @sektion.contact_page
    @page_content = "Kontaktinfo" if @page_content.blank?
  end

  def edit_contact
    @sektion = Sektion.find params[:id]
  end

  def export
    @sektion = Sektion.find params[:id]
    render :xlsx => 'export',
           :filename => "#{@sektion.name.downcase}-#{Time.now.strftime '%Y%m%d'}.xlsx",
           :disposition => 'attachment'
  end

  def edit
    @sektion = Sektion.find params[:id]
  end

  def update
    @sektion = Sektion.find params[:id]
    @sektion.update_attributes sektion_params
    handle_errors @sektion, 'Sektion uppdaterad'
  end


  def kollamedlem
    @sektion = Sektion.find(params[:id])
    authorize! :read, @sektion
    @karnevalister = @sektion.members.order('efternamn, fornamn asc')
  end

  def aktiva
    @sektion = Sektion.find(params[:id])
    authorize! :read, @sektion
    @karnevalister = @sektion.members.order('efternamn, fornamn asc')
  end
  private

  def sektion_params
    params.require(:sektion).permit!
  end
end
