# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user = create(:user)
    @relationship = build(:relationship, follower_id: @user.id, followed_id: @user.id)
  end
  context 'user_idがある場合' do
    it 'valid' do
      expect(@relationship).to be_valid
    end
  end
  describe 'presence' do
    context 'follower_idがnil場合' do
      it 'blank' do
        @relationship.follower_id = nil
        @relationship.valid?
        expect(@relationship.errors.details[:follower_id][0][:error]).to eq :blank
      end
    end

    context 'followed_idがnil場合' do
      it 'blank' do
        @relationship.followed_id = nil
        @relationship.valid?
        expect(@relationship.errors.details[:followed_id][0][:error]).to eq :blank
      end
    end
  end

  describe 'dependency' do
    context '関連付けられたfollowerが削除された場合' do
      it '削除される' do
        @relationship.follower.destroy
        expect(Relationship.all).not_to include @relationship
      end
    end

    context '関連付けられたfollowedが削除された場合' do
      it '削除される' do
        @relationship.followed.destroy
        expect(Relationship.all).not_to include @relationship
      end
    end
  end
end
