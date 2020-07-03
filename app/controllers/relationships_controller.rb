# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_designated_relationship, only: %i[destroy]
  before_action -> { check_permission(@relationship.follower) }, only: %i[destroy]

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user_path(user)
  end

  def destroy
    user = @relationship.followed
    current_user.unfollow(user)
    redirect_to user_path(user)
  end

  private

  def set_designated_relationship
    @relationship = Relationship.find(params[:id])
  end
end
