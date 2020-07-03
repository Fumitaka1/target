require 'rails_helper'

RSpec.describe 'relationships', type: :request do
  let(:relationship) { create(:relationship) }
  let(:user) { create(:user) }
  describe 'POST #create' do
    context 'ログインしている場合' do
      it 'インスタンスが作成される' do
        login user
        post relationships_path, params: { followed_id: user.id }
        expect(response.status).to eq 302
        expect { delete relationship_path(relationship) }.to change { Relationship.count }.by(1)
      end
    end
    context 'ログインしていない場合' do
      it 'サインインページにリダイレクトする' do
        post relationships_path
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe 'DELETE #destroy' do
    context '所有者の場合' do
      it 'インスタンスが削除される' do
        own_relationship = create(:relationship)
        login relationship.follower
        delete relationship_path(own_relationship)
        expect(response.status).to eq 302
        expect { delete relationship_path(relationship) }.to change { Relationship.count }.by(-1)
      end
    end
    context '所有者でない場合' do
      it 'ルートページにリダイレクトする' do
        not_own_relationship = create(:relationship)
        login user
        delete relationship_path(not_own_relationship)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    context 'ログインしていない場合' do
      it 'サインインページにリダイレクトする' do
        delete relationship_path(relationship)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
