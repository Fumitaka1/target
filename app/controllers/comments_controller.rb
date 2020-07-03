# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_designated_comment, except: :create
  before_action -> { check_permission(@comment.user) }, only: %i[edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to post_path(@comment.post)
    else
      render 'edit'
    end
  end

  def edit
    @post = @comment.post
    @comments = Comment.where(post_id: @post.id).paginate(page: params[:page], per_page: 20)
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_to post_path(@comment.post)
    else
      @post = @comment.post
      @comments = Comment.where(post_id: @post.id).paginate(page: params[:page], per_page: 20)
      render 'edit'
    end
  end

  def destroy
    flash[:notice] = '削除しました。'
    redirect_to post_path(@comment.post) if @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def set_designated_comment
    @comment = Comment.find(params[:id])
  end
end
