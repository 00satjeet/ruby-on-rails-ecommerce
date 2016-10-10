class SessionsController < ApplicationController

	def create
		user = User.where(:email => params[:email]).first
		# If the user exists AND the password entered is correct.
		if user && user.authenticate(params[:password])
			# Save the user id inside the browser cookie. This is how we keep the user 
			# logged in when they navigate around our website.
			session[:user_id] = user.id
			redirect_to '/'
		else
			# If login failed, send them back to the login form.
			redirect_to '/user/login'
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to '/user/login'
	end

end