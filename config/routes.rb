Rails.application.routes.draw do
	# Creates standard resource for CRUD operations
	resources :articles
	
	# Specify the page to load when index of the site is accessed
	root 'welcome#index'
end
