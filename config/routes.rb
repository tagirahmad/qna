# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

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

  resources :attachments, only: :destroy
  resources :links,       only: :destroy
  resources :rewards,     only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
