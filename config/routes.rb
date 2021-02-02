# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  concern :csvable do
    collection do
      post :import
      get :export
      get :export_template
    end
  end

  get 'admin', to: 'admin#index'
  get 'admin/:slug', to: 'admin#index'

  # devise_for :users
  namespace 'api' do
    namespace 'v1' do
      resource :setting
      resources :users, concerns: %i[csvable] do
        resource :profile
      end
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :articles, concerns: %i[csvable]
      resources :categories, concerns: %i[csvable]
      resources :comments, concerns: %i[csvable]
      resources :contacts, concerns: %i[csvable]
      resources :media, concerns: %i[csvable]
      resources :tags, concerns: %i[csvable]
    end
  end

  resources :tags, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :profiles, only: %i[index show]
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
