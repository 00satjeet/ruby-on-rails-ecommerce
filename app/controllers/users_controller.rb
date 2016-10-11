class UsersController < ApplicationController
	
	def new
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
			session[:user_id] = @user.id # Login the user
			respond_to do |format|
				format.json { render json: {:status => 1} }
			end
		else
			# Return errors from model into readable messages.
			respond_to do |format|
				format.json { render json: {:status => 0, :message => @user.errors.full_messages.to_sentence} }
			end
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
			respond_to do |format|
				format.json { render json: {:status => 1, :message => "Account sucessfully updated"} }
			end
		else
			# Return errors from model into readable messages.
			respond_to do |format|
				format.json { render json: {:status => 0, :message => @user.errors.full_messages.to_sentence} }
			end
		end
	end
end