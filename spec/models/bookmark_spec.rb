# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  before do
    user = create(:user)
    post = create(:post)
    @bookmark = build(:bookmark, user: user, post: post)
  end
  context 'user_idとpost_idがある場合' do
    it 'valid' do
      expect(@bookmark).to be_valid
    end
  end
  describe 'presence' do
    context 'userがnil場合' do
      it 'blank' do
        @bookmark.user = nil
        @bookmark.valid?
        expect(@bookmark.errors.details[:user][0][:error]).to eq :blank
      end
    end

    context 'post_idがnil場合' do
      it 'blank' do
        @bookmark.post = nil
        @bookmark.valid?
        expect(@bookmark.errors.details[:post][0][:error]).to eq :blank
      end
    end
  end

  describe 'dependency' do
    context '関連付けられたuserが削除された場合' do
      it '削除される' do
        @bookmark.user.destroy
        expect(Bookmark.all).not_to include @bookmark
      end
    end

    context '関連付けられたpostが削除された場合' do
      it '削除される' do
        @bookmark.post .destroy
        expect(Bookmark.all).not_to include @bookmark
      end
    end
  end
end
