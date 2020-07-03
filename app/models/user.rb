# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  mount_uploader :icon, IconUploader

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_PASSWORD_REGEX = %r{\A[\w[\(\)\[\]\{\}\.\?\+\-\*\|\\/][~!@#$%^&=:;<>,]]+\Z}.freeze

  validates :name, :email, :password, presence: true

  validates :name, :email, uniqueness: true

  validates :name, length: { maximum: 52 }
  validates :email, length: { maximum: 250 }
  validates :password, length: { in: 6..128 }

  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :password, format: { with: VALID_PASSWORD_REGEX }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked, through: :bookmarks, source: :post

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
