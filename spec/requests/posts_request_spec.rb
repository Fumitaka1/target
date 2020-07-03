require 'rails_helper'

RSpec.describe 'posts', type: :request do
  let(:article) { create(:post) }
  let(:user) { create(:user) }
  describe 'GET #new' do
    context 'ログインしている場合' do
      before { login user }
      it '新規投稿ページに遷移' do
        get new_post_path
        expect(response.status).to eq 200
        expect(response.body).to include '新規投稿'
      end
    end
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        get new_post_path
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #index' do
    context '検索ワードがある場合' do
      it '一致した記事が表示されること' do
        search_word = 'somesearchingword'
        create(:post, title: search_word)
        get "#{posts_url}?q=#{search_word}"
        expect(response.status).to eq 200
        expect(response.body).to include search_word
      end
    end
    context '検索ワードがない場合' do
      it 'リクエストが成功すること' do
        get posts_path
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #show' do
    it '記事詳細ページが表示されること' do
      get post_path(article)
      expect(response.status).to eq 200
      expect(response.body).to include article.title
    end
  end

  describe 'GET #edit' do
    context 'ログインしている場合' do
      before { login user }
      context '投稿の所有者の場合' do
        it '投稿編集ぺージに遷移すること' do
          own_article = create(:post, user_id: user.id)
          get edit_post_path(own_article)
          expect(response.status).to eq 200
          expect(response.body).to include '投稿編集'
        end
      end
      context '投稿の所有者でない場合' do
        it 'ルートページにリダイレクトされること' do
          get edit_post_path(article)
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        get edit_post_path(article)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'ログインしている場合' do
      before { login user }
      context '投稿の所有者の場合' do
        let(:own_article) { own_article = create(:post, user_id: user.id) }
        context 'パラメータが正常な場合' do
          let(:valid_attributes) { attributes_for(:post, user_id: user.id, title: 'changed') }
          it '投稿詳細ぺージにリダイレクトすること' do
            patch post_path(own_article), params: { post:  valid_attributes }
            expect(response.status).to eq 302
            expect(response).to redirect_to post_path(own_article)
          end
          it 'タイトルが更新されていること' do
            expect do
              patch post_path(own_article), params: { post:  valid_attributes }
            end.to change { Post.find(own_article.id).title }.from(own_article.title).to('changed')
          end
        end
        context 'パラメータが異常な場合' do
          let(:invalid_attributes) { attributes_for(:post, user_id: user.id, title: '') }
          it '投稿編集ぺージが表示されること' do
            patch post_path(own_article), params: { post: invalid_attributes }
            expect(response.status).to eq 200
            expect(response.body).to include  '投稿編集'
          end
          it 'タイトルが更新されていないこと' do
            expect do
              patch post_path(own_article), params: { post: invalid_attributes }
            end.to_not change(own_article, :title)
          end
        end
      end
      context '投稿の所有者でない場合' do
        it 'ルートページにリダイレクトされること' do
          patch post_path(article), params: { post: article.attributes }
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
        it 'タイトルが更新されていないこと' do
          changed_attributes = attributes_for(:post, user_id: user.id, title: 'changed')
          expect do
            patch post_path(article), params: { post: changed_attributes }
          end.to_not change(article, :title)
        end
      end
    end
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        patch post_path(article), params: { post: attributes_for(:post) }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      before { login user }
      context 'パラメータが正常な場合' do
        it '投稿詳細ぺージにリダイレクトすること' do
          valid_attributes = attributes_for(:post)
          post posts_path, params: { post:  valid_attributes }
          expect(response.status).to eq 302
          expect(response).to redirect_to post_path(Post.last)
        end
        it 'インスタンスが作成されること' do
          valid_attributes = attributes_for(:post)
          expect do
            post posts_path, params: { post: valid_attributes }
          end.to change { Post.count }.by(1)
        end
      end
      context 'パラメータが異常な場合' do
        let(:invalid_attributes) { attributes_for(:post, title: '') }
        it '新規投稿ページに遷移' do
          post posts_path, params: { post:  invalid_attributes }
          expect(response.status).to eq 200
          expect(response.body).to include '新規投稿'
        end
        it 'インスタンスが作成されないこと' do
          expect do
            post posts_path, params: { post: attributes_for(:post) }
          end.to_not change(User, :count)
        end
      end
    end
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        post posts_path, params: { post:  attributes_for(:post) }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      before { login user }
      context '投稿の所有者の場合' do
        let(:own_article) { own_article = create(:post, user_id: user.id) }
        it '投稿一覧ぺージにリダイレクトされること' do
          delete post_path(own_article)
          expect(response).to redirect_to posts_path
        end
        it 'インスタンスが削除されること' do
          own_article
          expect do
            delete post_path(own_article)
          end.to change { Post.count }.by(-1)
        end
      end
      context '投稿の所有者でない場合' do
        it 'ルートページにリダイレクトされること' do
          delete post_path(article)
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
        it 'インスタンスが削除されないこと' do
          article
          expect do
            delete post_path(article)
          end.to_not change(Post, :count)
        end
      end
    end
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトする' do
        delete post_path(article)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
