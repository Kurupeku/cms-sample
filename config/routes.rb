Rails.application.routes.draw do
  resources :tags, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :comments, only: %i[index show create]
  resources :profiles, only: %i[index show]
  devise_for :users
  resources :articles, only: [:show]
  root to: 'articles#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
