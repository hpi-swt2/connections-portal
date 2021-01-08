Rails.application.routes.draw do
  get 'social_accounts/new'
  get 'home/index'
  resources :notes
  # https://github.com/heartcombo/devise/wiki/
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :users, only: %i[show edit update] do
    patch 'status', to: 'users#update_status', as: 'update_status', on: :member

    resources :social_accounts
    resources :contacts, only: %i[index]
    resources :contact_requests, only: %i[index create destroy] do
      patch 'accept', on: :member
    end
  end
end
