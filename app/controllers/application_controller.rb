class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	
	# if they're logged in - save their user object to a variable called @current_user
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	
	# Make @current_user accessible in our view files.
	helper_method :current_user
	
	# Send user back to the login page if they are not logged-in
	def authorize
		redirect_to '/login' unless current_user
	end
end
