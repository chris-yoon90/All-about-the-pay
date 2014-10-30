Rails.application.routes.draw do
  root 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :employees do
    member do
      get :subordinates
    end
  end
  resources :groups
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :group_memberships, only: [ :create, :destroy ]
  resources :group_ownerships, only: [ :create, :destroy ]

end
