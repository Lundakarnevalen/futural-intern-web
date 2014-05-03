# -*- encoding : utf-8 -*-
class BookkeepingsController < ApplicationController
  authorize_resource
  def index
    @bookkeepings = Bookkeeping.all
    @dates = Bookkeeping.find_dates
  end

  def new
    @bookkeeping = current_user.karnevalist.bookkeepings.new
  end

  def create
    @bookkeeping = current_user.karnevalist.bookkeepings.new(bookkeeping_params)
    @bookkeeping.karnevalist_id = current_user.karnevalist.id
    if @bookkeeping.save
      redirect_to action: "index"
    else
      render :new
    end
  end

  def show
    @bookkeeping = Bookkeeping.find params[:id]
  end

  def diagram
    @date = params[:date]

  end

  private
    def bookkeeping_params
      params.require(:bookkeeping).permit( :question_1, :question_2, :question_3, :question_4 )
    end
  
end