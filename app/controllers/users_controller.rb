class UsersController < ApplicationController
	
	def new
		# Pass the @user variable, which contains errors, to the view: "articles/new"  
		@user = User.new
    end

    def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			redirect_to '/'
		else
			# Use same request during form submit to redirect user back to the form 
			# This will call for the function "new" and it passes @article variable containing the errors
			render "new"
		end
    end
	
	private
		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone_number)
		end
	
end