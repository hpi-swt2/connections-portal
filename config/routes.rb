Rails.application.routes.draw do
  resources :room_messages, only: :create
  resources :notes
  # https://github.com/heartcombo/devise/wiki/
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#dashboard'

  resources :users, only: %i[show edit update index] do
    patch 'status', to: 'users#update_status', as: 'update_status', on: :member

    resources :social_accounts
    get 'search', to: 'users#search', on: :collection
    resources :contacts, only: %i[index]
    resources :contact_requests, only: %i[index create destroy] do
      patch 'accept', on: :member
    end
  end

  resources :activities, only: :create
  resources :jitsi_calls, only: :create

  get 'chat', to: 'home#chat'
end
