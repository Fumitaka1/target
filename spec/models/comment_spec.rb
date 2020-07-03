# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    user = create(:user)
    post = create(:post)
    @comment = build(:comment, user: user, post: post)
  end
  context 'contentとuser_idとpost_idがある場合' do
    it 'valid' do
      expect(@comment).to be_valid
    end
  end
  describe 'presence' do
    context 'userがnil場合' do
      it 'invalid' do
        @comment.user = nil
        @comment.valid?
        @comment.inspect
        expect(@comment.errors.details[:user][0][:error]).to eq :blank
      end
    end

    context 'post_idがnil場合' do
      it 'invalid' do
        @comment.post = nil
        @comment.valid?
        expect(@comment.errors.details[:post][0][:error]).to eq :blank
      end
    end

    context 'contentがnil場合' do
      it 'invalid' do
        @comment.content = nil
        @comment.valid?
        expect(@comment.errors.details[:content][0][:error]).to eq :blank
      end
    end

    context 'contentが" "場合' do
      it 'invalid' do
        @comment.content = ' '
        @comment.valid?
        expect(@comment.errors.details[:content][0][:error]).to eq :blank
      end
    end
  end

  describe 'length' do
    context 'contentが400文字の場合' do
      it 'valid' do
        @comment.content = 'a' * 400
        expect(@comment).to be_valid
      end
    end

    context 'contentが401文字の場合' do
      it 'valid' do
        @comment.content = 'a' * 401
        @comment.valid?
        expect(@comment.errors.details[:content][0][:error]).to eq :too_long
      end
    end
  end
end
