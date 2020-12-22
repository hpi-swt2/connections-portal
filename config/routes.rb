Rails.application.routes.draw do
  get 'home/index'
  resources :notes
  # https://github.com/heartcombo/devise/wiki/
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get "/:contacts" => "contacts#show"

  resources :users, only: %i[show edit update] do
    member do
      patch 'status', to: 'users#update_status', as: 'update_status'
      patch 'send_contact_request'
      get 'view_contact_request'
      patch 'deny_contact_request'
    end
  end
end
