require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  describe 'GET #index' do
    it 'ステータスコード200を返す' do
      get users_path
      expect(response.status).to eq 200
    end
  end
  describe 'GET #show' do
    it 'ステータスコード200を返す' do
      get user_path(user)
      expect(response.status).to eq 200
    end
  end
  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      it 'userが削除されること' do
        login user
        expect do
          delete user_path(user)
        end.to change { User.count }.by(-1)
      end
    end
    context 'ログインしていない場合' do
      it 'サインインページにリダイレクトする' do
        delete user_path(user)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    context '所有者でない場合' do
      before do
        login user
        another_user = create(:user)
        delete user_path(another_user)
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
