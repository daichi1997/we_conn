Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users, only: [:show,:edit,:update]  
  resources :events do
    resources :event_steps, only: [:show, :update]
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create,:edit,:update,:destroy] 
   end
  resources :comments do
  member do
    post 'toggle_owner_like'
  end
 end

  get 'events/new/event_steps/:id', to: 'event_steps#show', as: :new_event_step
  patch 'events/new/event_steps/:id', to: 'event_steps#update'
  post 'events/new/event_steps/:id', to: 'event_steps#update'  
  root to: 'home#index'

end
