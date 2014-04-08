class PostsController < ApplicationController
  skip_authorization_check
  layout 'home/application'

  def new
    @tilldelade_sektioner = current_user.karnevalist.tilldelade_sektioner
    @post = Post.new
  end

  def create
    p = params[:post]
    sektion_id = p[:sektion].to_i
    p[:sektion] = Sektion.find(sektion_id)
    p[:karnevalist] = current_user.karnevalist
    #p[:content] = markdown p[:content]
    @post = Post.new(p)
    if @post.save
      flash[:success] = "Inlägg skapat!"
    end
    redirect_to root_url
  end

  def edit
    @post = current_user.karnevalist.sektion.posts.find_by(id: params[:id])
    @tilldelade_sektioner = current_user.karnevalist.tilldelade_sektioner
  end

  def update
    @post = current_user.karnevalist.sektion.posts.find_by(id: params[:id])
    p = params[:post]
    sektion_id = p[:sektion].to_i
    p[:sektion] = Sektion.find(sektion_id)
    #p[:content] = markdown p[:content]
    if @post.update_attributes(p)
      flash[:success] = "inlägg redigerat"
    end
    redirect_to @post
  end

  def destroy
    post = current_user.karnevalist.sektion.posts.find_by(id: params[:id])
    post.destroy
    redirect_to root_url
  end

  def show
    @post = current_user.karnevalist.sektion.posts.find_by(id: params[:id])
    @post_html = markdown @post.content
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :sektion)
  end

  # Process text with Markdown.
  def markdown(text)
    BlueCloth.new(text).to_html
  end
end
