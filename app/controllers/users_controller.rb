class UsersController < ApplicationController
	
	def new
		# Pass the @user variable, which contains errors, to the view: "articles/new"  
		@user = User.new
    end

    def create
		@params = params.require(:user).permit(
			:email, 
			:password, 
			:password_confirmation, 
			:first_name, 
			:last_name, 
			:phone_number
		)
		@user = User.new(@params)
		
		if @user.save
			session[:user_id] = @user.id
			redirect_to '/'
		else
			# Use same request during form submit to redirect user back to the form 
			# This will call for the function "new" and it passes @user variable containing the errors
			render "new"
		end
    end
	
	def edit
		# Pass the @user variable, which contain the post data, to the view "user/edit"
		@user = User.find(current_user._id)
	end
	
	def update
		@params = params.require(:user).permit(
			:password, 
			:password_confirmation, 
			:first_name, 
			:last_name, 
			:phone_number,
			:about_me
		)
		@user = User.find(current_user._id)

		if @user.update(@params)
			redirect_to '/user/account'
		else
			render "edit"
		end
	end
	
end