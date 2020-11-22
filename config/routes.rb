Rails.application.routes.draw do
  resources :tags
  resources :categories
  resources :comments
  resources :profiles
  devise_for :users
  resources :articles, except: [:index]
  root to: 'articles#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
