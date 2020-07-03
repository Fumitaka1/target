require 'rails_helper'

RSpec.describe 'comments', type: :request do
  let(:comment) { create(:comment) }
  let(:user) { create(:user) }
  describe 'POST #create' do
    before { post comments_path }
    context 'ログインしていない場合' do
      it 'ステータスコード302を返す' do
        expect(response.status).to eq 302
      end
      it 'サインインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe 'DELETE #destroy' do
    context 'ログインしていない場合' do
      before { delete comment_path(comment) }
      it 'ステータスコード302を返す' do
        expect(response.status).to eq 302
      end
      it 'サインインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context '所有者でない場合' do
      before do
        login user
        another_users_comment = create(:comment)
        delete comment_path(another_users_comment)
      end
      it 'ステータスコード302を返す' do
        expect(response.status).to eq 302
      end
      it 'ルートページにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
