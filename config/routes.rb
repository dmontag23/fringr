Rails.application.routes.draw do
  
  get 'password_resets/new'

  get 'password_resets/edit'

  get    '/about',      to: 'static_pages#about'
  get    '/contact_me', to: 'static_pages#contact'
  get    '/signup',     to: 'users#new'
  post   '/signup',     to: 'users#create'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

	root 'static_pages#home'

  concern :bookings do
    resources :conflicts, only: [:create, :index, :destroy]
  end
  
  resources :users,               only: [:new, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :contacts,            only: [:create, :index, :destroy],       concerns: :bookings
  resources :locations,           only: [:create, :index, :destroy],       concerns: :bookings         
  resources :schedules,           except: [:index] do
    member do
      get 'view'
      post 'view', to: 'schedules#schedule'
    end
    resources :pieces, except: [:index] do
      member do
        get 'manually_schedule'
        patch 'manually_schedule', to: 'pieces#manually_schedule_piece'
      end
    end
  end

  namespace :api do
    get 'calendar_events/check_piece', to: 'calendar_events#check_piece'
    resources :calendar_events
  end
  
end
