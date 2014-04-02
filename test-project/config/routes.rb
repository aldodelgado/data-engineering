TestProject::Application.routes.draw do
  devise_for :users, :controllers => {
    :registrations =>  'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations',
    :omniauth_callbacks => 'users/omniauth_callbacks'
  }

  root 'pages#index'
end
