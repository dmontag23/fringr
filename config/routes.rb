Rails.application.routes.draw do
  
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
	root 'static_pages#home'

end
