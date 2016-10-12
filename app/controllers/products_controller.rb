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
