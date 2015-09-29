Rails.application.routes.draw do
  devise_for :users

  root 'messages#index'

  namespace :admin do
    resources :users, except: :show do
      post :reset_password, on: :member
    end
  end

  resources :messages, only: %w(index create show)

end
