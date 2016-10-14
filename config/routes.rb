Rails.application.routes.draw do
	# Creates standard resource for products CRUD operations
	resources :products
	# Include other products rotues
	post '/products/all' => 'products#all'

	# Creates standard resource for articles CRUD operations
	resources :articles
	
	# Specify the page to load when index of the site is accessed
	root 'welcome#index'

	get '/user/login' => 'sessions#new'
	post '/user/login' => 'sessions#create'
	get '/user/logout' => 'sessions#destroy'

	get '/user/register' => 'users#new'
	post '/user/register' => 'users#create'
	get '/user/account' => 'users#edit'
	post '/user/account' => 'users#update'
end
