# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  
  concern :voteble do
    member do
      patch :vote_up
      patch :vote_down
      delete :unvote
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[voteble commentable] do
    resources :answers, concerns: %i[voteble commentable], shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  resources :attachments, only: :destroy
  resources :links,       only: :destroy
  resources :rewards,     only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
