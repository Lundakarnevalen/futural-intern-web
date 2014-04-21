# -*- encoding : utf-8 -*-
class PostsController < ApplicationController
  authorize_resource

  def new
    @post = Post.new :sektion_id => current_sektioner.first.id
  end

  def create
    @post = Post.new post_params
    @post.karnevalist = current_karnevalist
    authorize_sektion @post
    @post.save
    handle_errors @post, 'Nyheten skapades!', :redirect => @post
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    @post = Post.find params[:id]
    authorize_sektion @post
    @post.update_attributes post_params
    handle_errors @post, 'Nyheten ändrades'
  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy
    handle_errors @post, 'Nyheten togs bort', :redirect => root_url
  end

  def show
    @post = Post.find params[:id]
  end

  def authorize_sektion post
    if post.sektion.nil? || ! current_sektioner.include?(post.sektion)
      authorize! :modify, Post.new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :sektion_id)
  end
end
