# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#post' do
    context 'タイトルとコンテンツと実在するユーザーidがある場合' do
      it '投稿できる' do
        expect(FactoryBot.create(:post)).to be_valid
      end
    end

    context 'タイトルが無い場合' do
      it '投稿できない' do
        expect(FactoryBot.build(:post, title: '')).to be_invalid
      end
    end

    context 'タイトルが140文字の場合' do
      it '投稿できる' do
        expect(FactoryBot.build(:post, title: 'a' * 140)).to be_valid
      end
    end

    context 'タイトルが141文字の場合' do
      it '投稿できない' do
        expect(FactoryBot.build(:post, title: 'a' * 141)).to be_invalid
      end
    end

    context 'コンテンツが無い場合' do
      it '投稿できない' do
        expect(FactoryBot.build(:post, content: '')).to be_invalid
      end
    end

    context 'コンテンツが40,000文字の場合' do
      it '投稿できる' do
        expect(FactoryBot.build(:post, content: 'a' * 40_000)).to be_valid
      end
    end

    context 'コンテンツが40,001文字の場合' do
      it '投稿できない' do
        expect(FactoryBot.build(:post, content: 'a' * 40_001)).to be_invalid
      end
    end
  end
end
