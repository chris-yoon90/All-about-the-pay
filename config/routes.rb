Rails.application.routes.draw do
  
  get 'groups/index'

  get 'groups/show'

  get 'groups/edit'

  get 'groups/new'

  get 'sessions/new'

  root 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :employees#, only: [ :new ]
  resources :sessions, only: [ :new, :create ]

end
