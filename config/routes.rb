Rails.application.routes.draw do
  root 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :employees do
    member do
      get :subordinates
      get :owned_groups
    end
  end
  resources :groups do
    member do
      get :search_owner
      get :search_member
    end
  end
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :group_memberships, only: [ :create, :destroy ]
  resources :group_ownerships, only: [ :create, :destroy ]

end
