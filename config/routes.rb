Rails.application.routes.draw do

  devise_for :users

  namespace :admin do
    resources :charities,:users
  end

  post 'donate', to: 'website#donate', as: 'donate'

  root to: 'website#index'

end
