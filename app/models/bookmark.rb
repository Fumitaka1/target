# frozen_string_literal: true

class Bookmark < ApplicationRecord
  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :post
  belongs_to :user
end
