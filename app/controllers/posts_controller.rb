class PostsController < ApplicationController
  skip_authorization_check

  def new
    @post = Post.new
  end

  def create
    p = params[:post]
    sektion_id = p[:sektion].to_i
    p[:sektion] = Sektion.find(sektion_id)
    p[:karnevalist] = current_karnevalist
    @post = Post.new(p)
    if @post.save
      flash[:success] = "Nyhet skapad!"
    end
    redirect_to root_url
  end

  def edit
    @post = Post.find params[:id]
    @tilldelade_sektioner = current_sektioner
  end

  def update
    @post = Post.find params[:id]
    p = params[:post]
    sektion_id = p[:sektion].to_i
    p[:sektion] = Sektion.find(sektion_id)
    if @post.update_attributes(p)
      flash[:success] = "Nyhet redigerad"
    end
    redirect_to @post
  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy
    redirect_to root_url
  end

  def show
    @sektioner = current_sektioner
    @sektioner.each do |s|
      p = s.posts.find_by(id: params[:id])
      @post = p unless p.nil?
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :sektion)
  end
end
