Rails.application.routes.draw do
  resources :tags, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :profiles, only: %i[index show]
  devise_for :users
  resources :articles, only: [:show] do
    resources :comments, only: %i[create]
  end
  resources :contacts, only: %i[new create] do
    collection do
      get 'thanks'
    end
  end
  root to: 'articles#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
