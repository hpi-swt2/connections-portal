Rails.application.routes.draw do
  get 'home/index'
  resources :notes
  # https://github.com/heartcombo/devise/wiki/
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get "/:contacts" => "contacts#show"
end
