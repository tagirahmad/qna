# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get :search, to: 'search#search'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit]
      end
    end
  end

  resources :attachments,   only: :destroy
  resources :links,         only: :destroy
  resources :rewards,       only: :index
  resources :subscriptions, only: %i[create destroy]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
