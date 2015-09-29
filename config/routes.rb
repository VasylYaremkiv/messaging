Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  namespace :admin do
    resources :users, except: :show do
      post :reset_password, on: :member
    end
  end

end
