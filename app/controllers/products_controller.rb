class ProductsController < ApplicationController
	def index
	end

	def new
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
		@product = Product.find(params[:id])
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
