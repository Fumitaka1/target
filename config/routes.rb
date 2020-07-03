# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users,only: %i[destroy index show] do
    member do
      get :following, :followers, :bookmarks
    end
  end
  resources :posts
  resources :comments, except: %i[new show index]
  resources :relationships, only: %i[create destroy]
  resources :bookmarks, only: %i[create destroy]
end
