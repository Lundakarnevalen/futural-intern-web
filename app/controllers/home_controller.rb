class HomeController < ApplicationController
  skip_authorization_check

  def index
    unless signed_in?
      redirect_to new_karnevalist_path
    end
    @sektion = Sektion.find(1)
    @posts = Sektion.find(1).posts
  end

  def show
    #@sektion = Karnevalist.find(params[:id]).sektion
    @sektion = Sektion.find(1)
    @posts = @sektion.posts.paginate(page: params[:page])
  end

end
