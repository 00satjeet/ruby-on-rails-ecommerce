class ProductsController < ApplicationController
	require 'pp'
	
	def index
	end
	
	def all
		if params[:product]
			# Parse received product JSON object
			@post_data = JSON.parse(params[:product])
			
			@pagination_content = ""
			@page_number = @post_data["page"] ? @post_data["page"].to_i : 1
			
			@page = @page_number
			@name = @post_data["name"]
			@sort = @post_data["sort"]
			@search = @post_data["search"]
			@max = @post_data["max"].to_i
			
			@cur_page = @page
			@page -= 1
			@per_page = @max # Set the number of results to display
			@previous_btn = true
			@next_btn = true
			@first_btn = true
			@last_btn = true
			@start = @page * @per_page
			
			@pagination_content = ""
			@pagination_nav = ""
			
			# If search keyword is not empty, we include a query for searching 
			# the "content" or "name" fields in the database for any matched strings.
			if @search.present?
				@search_by_name = { :name => /.*#{@search}.*/ }
				@search_by_content = { :content => /.*#{@search}.*/ }
				@all_posts = Product
					.any_of(@search_by_name)
					.any_of(@search_by_content)
					.limit(@per_page)
					.offset(@start)
					.order(@name + " " + @sort)
				@count = Product
					.any_of(@search_by_name)
					.any_of(@search_by_content)
					.length
			else
				@all_posts = Product
					.limit(@per_page)
					.offset(@start)
					.order(@name + " " + @sort)
				@count = Product.all.length
			end
			
			if @all_posts.present?
				@all_posts.each do |post, value|
					@pagination_content += "
						<div class='col-sm-3'>
							<div class='panel panel-default'>
								<div class='panel-heading'>#{post.name}</div>
								<div class='panel-body p-0 p-b'>
									<a href='products-single.php?item=57c913bc4534e0640d00002a'>
										<img src='img/uploads/nWq7KBn9g9fvWNckEa7D.jpg' width='100%' class='img-responsive'>
									</a>
									<div class='list-group m-0'>
										<div class='list-group-item b-0 b-t'>
											<i class='fa fa-calendar-o fa-2x pull-left ml-r'></i>
											<p class='list-group-item-text'>Price</p>
											<h4 class='list-group-item-heading'>$#{post.price}</h4>
										</div>
										<div class='list-group-item b-0 b-t'>
											<i class='fa fa-calendar fa-2x pull-left ml-r'></i>
											<p class='list-group-item-text'>On Stock</p>
											<h4 class='list-group-item-heading'>#{post.quantity}</h4>
										</div>
									</div>
								</div> 
								<div class='panel-footer'>
									<a href='#{product_url(post)}' class='btn btn-primary btn-block'>View Item</a>
								</div>
							</div>
						</div>
					"
				end
			else
				@pagination_content += "<p class='bg-danger p-d'>No results</p>"
			end
			
			# Optional, wrap the output into a container
			@pagination_content = "<div class='cvf-universal-content'>#{@pagination_content}</div><br class = 'clear' />";

			@no_of_paginations = (@count.fdiv(@per_page)).ceil
			
			if @cur_page >= 7 
				@start_loop = @cur_page - 3
				if @no_of_paginations > @cur_page + 3
					@end_loop = @cur_page + 3
				elsif @cur_page <= @no_of_paginations && @cur_page > @no_of_paginations - 6
					@start_loop = @no_of_paginations - 6
					@end_loop = @no_of_paginations
				else
					@end_loop = @no_of_paginations
				end
			else
				@start_loop = 1
				if @no_of_paginations > 7
					@end_loop = 7
				else
					@end_loop = @no_of_paginations
				end
			end

			# Pagination Buttons logic     
			@pagination_nav += "
				<div class='pagination-container'>
					<ul>"

			if @first_btn && @cur_page > 1
				@pagination_nav += "<li p='1' class='active'>First</li>"
			elsif @first_btn
				@pagination_nav += "<li p='1' class='inactive'>First</li>"
			end

			if @previous_btn && @cur_page > 1
				@pre = @cur_page - 1
				@pagination_nav += "<li p='#{@pre}' class='active'>Previous</li>"
			elsif @previous_btn
				@pagination_nav += "<li class='inactive'>Previous</li>"
			end
			
			for @i in @start_loop..@end_loop do
				if @cur_page == @i
					@pagination_nav += "<li p='#{@i}' class = 'selected'>#{@i}</li>"
				else
					@pagination_nav += "<li p='#{@i}' class='active'>#{@i}</li>"
				end
			end

			if @next_btn && @cur_page < @no_of_paginations
				@nex = @cur_page + 1
				@pagination_nav += "<li p='#{@nex}' class='active'>Next</li>"
			elsif @next_btn
				@pagination_nav += "<li class='inactive'>Next</li>"
			end

			if @last_btn && @cur_page < @no_of_paginations
				@pagination_nav += "<li p='#{@no_of_paginations}' class='active'>Last</li>"
			elsif @last_btn
				@pagination_nav += "<li p='#{@no_of_paginations}' class='inactive'>Last</li>"
			end

			@pagination_nav = "#{@pagination_nav}
					</ul>
				</div>"
			
			respond_to do |format|
				format.json { render json: {:content => @pagination_content, :navigation => @pagination_nav} }
			end
			
		end
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
