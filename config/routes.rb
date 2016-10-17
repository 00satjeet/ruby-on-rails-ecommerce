Rails.application.routes.draw do
	
	# Other products rotues
	post '/products/all' => 'products#all'
	get '/products/user' => 'products#user'
	post '/products/user' => 'products#user'
	post '/products/set-featured-image' => 'products#set_featured_image'
	post '/products/unset-image' => 'products#unset_image'
	post '/products/destroy' => 'products#destroy'
	
	# Creates standard resource for products CRUD operations
	resources :products
	
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
