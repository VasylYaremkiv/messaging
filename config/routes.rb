Rails.application.routes.draw do
  devise_for :users

  root 'contacts#index'

  namespace :admin do
    resources :users, except: :show do
      post :reset_password, on: :member
    end
  end

  resources :contacts, only: %w(index create show) do
    post :create_message, on: :member
    get :amount_unread_message, on: :collection
  end

  resource :profile, only: %w(edit update)

end
