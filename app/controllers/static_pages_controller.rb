# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    @posts = Post.paginate(page: params[:page], per_page: 20)
  end
end
