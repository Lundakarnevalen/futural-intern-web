# -*- encoding : utf-8 -*-
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
    @page_content = @sektion.info_page
    if @page_content.blank?
      @page_content = "Snart kommer du kunna läsa information om din sektion här."
    end
  end

  def show_english
    @sektion = Sektion.find params[:id]
    @page_content = @sektion.english_page
    if @page_content.blank?
      @page_content = "In English."
    end
  end

  def edit_english
    @sektion = Sektion.find params[:id]
  end

  def show_contact
    @sektion = Sektion.find params[:id]
    @page_content = @sektion.contact_page
    if @page_content.blank?
      @page_content = "Such Concact"
    end
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
    p = params[:sektion]
    if @sektion.update_attributes(p)
      flash[:success] = "Sektionsinfo redigerat"
    end
    redirect_to @sektion
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
    params.require(:sektion).permit(:info_page, :english_page, :contact_page)
  end
end
