# -*- encoding : utf-8 -*-
class BookkeepingsController < ApplicationController
  authorize_resource
  def index

  end

  def new
    @bookkeeping = current_user.karnevalist.bookkeepings.new
  end
end