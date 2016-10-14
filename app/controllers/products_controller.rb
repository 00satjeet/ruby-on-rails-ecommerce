class ProductsController < ApplicationController
	
	require 'pp'
	include ApplicationHelper
	
	def index
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
									<a href='#{product_path(post)}' class='btn btn-primary btn-block'>View Item</a>
								</div>
							</div>
						</div>
					"
				end
			else
				@pagination_content += "<p class='bg-danger p-d'>No results</p>"
			end
			
			respond_to do |format|
				format.json { render json: {
					:content => @pagination_content, 
					:navigation => nagivation_list(@count, @per_page, @cur_page)
				} }
			end
			
		end
	end
	
	def user
		if params[:product]
			# Parse received product JSON object
			@post_data = JSON.parse(params[:product])
			
			@pagination_content = ""
			@page_number = @post_data["page"] ? @post_data["page"].to_i : 1
			@page = @page_number
			@name = @post_data["th_name"]
			@sort = @post_data["th_sort"]
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
					.where(author: current_user._id)
					.any_of(@search_by_name)
					.any_of(@search_by_content)
					.limit(@per_page)
					.offset(@start)
					.order(@name + " " + @sort)
				@count = Product
					.where(author: current_user._id)
					.any_of(@search_by_name)
					.any_of(@search_by_content)
					.length
			else
				@all_posts = Product
					.where(author: current_user._id)
					.limit(@per_page)
					.offset(@start)
					.order(@name + " " + @sort)
				@count = Product
					.where(author: current_user._id)
					.length
			end
			
			if @all_posts.present?
				@all_posts.each do |post, value|
					@pagination_content += "
						<tr>
							<td></td>
							<td>#{post.name}</td>
							<td>#{post.price}</td>
							<td>#{post.status}</td>
							<td></td>
							<td>#{post.quantity}</td>
							<td>
								<a href='#{edit_product_path(post)}' class='text-success'>
									<span class='glyphicon glyphicon-pencil' title='Edit'></span>
								</a> &nbsp; &nbsp;
								<a href='#' class='text-danger delete-product' item_id=''>
									<span class='glyphicon glyphicon-remove' title='Delete'></span>
								</a>
							</td>
						</tr>
					"
				end
			else
				@pagination_content += "<tr><td colspan='7' class='bg-danger p-d'>No results</td></tr>"
			end
			
			respond_to do |format|
				format.json { render json: {
					:content => @pagination_content, 
					:navigation => nagivation_list(@count, @per_page, @cur_page)
				} }
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
		@posted_images = []
		
		# Check if there are any images posted
		if params[:product]['images'][0] != ""
			# Upload images then save to database
			
			@existing_images = @product.images ? @product.images : []
			params[:product]['images'].each do |a|
				# Generate random name for the image file
				@random_string = (0...50).map { ('a'..'z').to_a[rand(26)] }.join + File.extname(a.original_filename)
				File.open(Rails.root.join('public', 'uploads', @random_string), 'wb') do |file|
					# Write data to public/uploads folder
					file.write(a.read)
				end
				# Add image name to @posted_images object
				@posted_images << @random_string
			end
			
			# Insert images to database as array.
			@product.assign_attributes(:images => @posted_images + @existing_images)
		end
		
		if @product.update(@params)
			respond_to do |format|
				@main_response = {:status => 1, :message => "Product successfully updated"}
				
				if @posted_images.blank?
					format.json { render json: @main_response }
				else
					# Merge our images hash to to main response
					format.json { render json: @main_response.merge({:images => @posted_images}) }
				end
				
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
