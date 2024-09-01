Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users, only: [:show,:edit,:update]  
  resources :events do
    resources :event_steps,controller: 'event_steps' do
      delete 'delete_image', on: :member
   end
 end
  root to: 'home#index'

end
