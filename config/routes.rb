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

  resources :questions, concerns: :voteble do
    resources :answers, concerns: :voteble, shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links,       only: :destroy
  resources :rewards,     only: :index

  root to: 'questions#index'
end
