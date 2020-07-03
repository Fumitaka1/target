# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_designated_bookmark, only: %i[destroy]
  before_action -> { check_permission(@bookmark.user) }, only: %i[destroy]

  def index
    @bookmarks = current_user.bookmarks.paginate(page: params[:page], per_page: 20)
  end

  def create
    post_id = params[:post_id]
    current_user.bookmarks.create(post_id: post_id)
    redirect_to Post.find(post_id)
  end

  def destroy
    @bookmark.destroy
    redirect_to @bookmark.post
  end

  private

  def set_designated_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
end
