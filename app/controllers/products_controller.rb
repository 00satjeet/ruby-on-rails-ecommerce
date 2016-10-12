class ProductsController < ApplicationController
	require 'pp'
	
	def index
	end

	def new
		# Redirect if not logged-in
		if ! current_user
			redirect_to '/'
		end
	end

	def create
		@params = params.require(:product).permit(
			:name, 
			:content, 
			:excerpt, 
			:price, 
			:status, 
			:quantity
		)
		@product = Product.new(@params)
		
		if @product.save
			respond_to do |format|
				format.json { render json: {:status => 1, :message => @product._id} }
			end
		else
			# Return errors from model into readable messages.
			respond_to do |format|
				format.json { render json: {:status => 0, :message => @product.errors.full_messages.to_sentence} }
			end
		end
	end

	def edit
		@product = Product.where(:_id => params[:id]).first
		
		# Redirect if not logged in or user is not author of the product
		if ! current_user || current_user._id != @product.author
			redirect_to '/'
		end
	end

	def update
		@params = params.require(:product).permit(
			:name, 
			:content, 
			:excerpt, 
			:price, 
			:status, 
			:quantity,
			:images
		)
		@product = Product.find(params[:id])
		@product.assign_attributes({:author => current_user._id}) # Assign current user as the author of the product
		
		# Upload images then save to database
		if ! params[:product]['images'].nil?
			@image_data = []
			params[:product]['images'].each do |a|
				# Generate random name for the image file
				@random_string = (0...50).map { ('a'..'z').to_a[rand(26)] }.join + File.extname(a.original_filename)
				File.open(Rails.root.join('public', 'uploads', @random_string), 'wb') do |file|
					# Write data to public/uploads folder
					file.write(a.read)
				end
				# Add image name to @image_data object
				@image_data << @random_string
			end
			
			# Insert images to database as array.
			@product.assign_attributes(:images => @image_data)
		end
		
		if @product.update(@params)
			respond_to do |format|
				format.json { render json: {:status => 1, :message => "Product successfully updated"} }
			end
		else
			# Return errors from model into readable messages.
			respond_to do |format|
				format.json { render json: {:status => 0, :message => @product.errors.full_messages.to_sentence} }
			end
		end
	end

	def destroy
	end

	def show
	end
end
