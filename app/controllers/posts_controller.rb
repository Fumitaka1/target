# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit create update destroy]
  before_action :set_post_find_by_id, only: %i[edit show update destroy]
  before_action :set_posts_search_result, only: :index
  before_action -> { check_permission(@post.user) }, only: %i[edit update destroy]

  def index; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post)
    else
      render '/posts/new'
    end
  end

  def new
    @post = Post.new
  end

  def edit; end

  def show
    @comment = Comment.new(post_id: @post.id)
    @comments = Comment.where(post_id: @post.id).paginate(page: params[:page], per_page: 20)
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = '削除しました。'
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :remove_image)
  end

  def set_post_find_by_id
    @post = Post.find(params[:id])
  end

  def set_posts_search_result
    search_result = Post.where("title LIKE ?", "%#{params[:q]}%")
    @posts = search_result.paginate(page: params[:page], per_page: 20)
  end
end
