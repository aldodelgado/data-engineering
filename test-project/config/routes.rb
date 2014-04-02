TestProject::Application.routes.draw do
  devise_for :users, :controllers => {
    :registrations =>  'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations',
    :omniauth_callbacks => 'users/omniauth_callbacks'
  }

  authenticate :user do
    namespace :users do
      resources :uploads
      resources :profile, :only => [:edit, :update]
      root :to => 'users#index'
    end
  end

  root 'pages#index'
end
