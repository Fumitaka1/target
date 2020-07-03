require 'rails_helper'

RSpec.describe 'bookmarks', type: :request do
  let(:bookmark) { create(:bookmark) }
  let(:user) { create(:user) }
  let(:target_post) { create(:post) }
  describe 'POST #create' do
    context 'ログインしている場合' do
      it '対象の記事にリダイレクトする' do
        login user
        post bookmarks_path, params: { post_id: target_post.id }
        expect(response).to redirect_to target_post
        expect(response.status).to eq 302
      end
      it 'インスタンスが作成される' do
        login user
        expect { post bookmarks_path, params: { post_id: target_post.id } }.to change { Bookmark.count }.by(1)
      end
    end
    context 'ログインしていない場合' do
      it 'サインインページにリダイレクトする' do
        post bookmarks_path, params: { post_id: target_post.id }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe 'DELETE #destroy' do
    context '所有者の場合' do
      it '対象の記事にリダイレクトする' do
        own_bookmark = create(:bookmark)
        login own_bookmark.user
        delete bookmark_path(own_bookmark)
        expect(response.status).to eq 302
        expect(response).to redirect_to own_bookmark.post
      end
      it 'インスタンスが削除される' do
        own_bookmark = create(:bookmark)
        login own_bookmark.user
        expect { delete bookmark_path(own_bookmark) }.to change { Bookmark.count }.by(-1)
      end
    end
    context '所有者でない場合' do
      it 'ルートページにリダイレクトする' do
        not_own_bookmark = create(:bookmark)
        login user
        delete bookmark_path(not_own_bookmark)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    context 'ログインしていない場合' do
      it 'サインインページにリダイレクトする' do
        delete bookmark_path(bookmark)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
