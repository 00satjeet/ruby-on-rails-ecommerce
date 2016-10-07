class ArticlesController < ApplicationController
	
	include ActionView::Helpers::TextHelper
	
	def index
		@pagination_content = ""
		@page_number = params["pageno"] ? params["pageno"].to_i : 1
		  
		@page = @page_number
		@cur_page = @page
		@page -= 1
		# Set the number of results to display
		@per_page = 3 
		@previous_btn = true
		@next_btn = true
		@first_btn = true
		@last_btn = true
		@start = @page * @per_page
		
		@pagination_content = ""
		@pagination_nav = ""
		
		@all_blog_posts = Article.limit(@per_page).offset(@start).order('title ASC')
		@count = Article.all.length
		
		if @all_blog_posts.present?
			@all_blog_posts.each do |post, value|
				@pagination_content += "
					<h4>#{post.title}</h4>
					#{truncate(strip_tags(post.text), :length => 500)}
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
			@pagination_nav += "<li class='active'><a href = '#{@current_page_url}?pageno=1'>First</a></li>"
		elsif @first_btn
			@pagination_nav += "<li class='inactive'>First</li>"
		end

		if @previous_btn && @cur_page > 1
			@pre = @cur_page - 1
			@pagination_nav += "<li class='active'><a href = '#{@current_page_url}?pageno=#{@pre}'>Previous</a></li>"
		elsif @previous_btn
			@pagination_nav += "<li class='inactive'>Previous</li>"
		end
		
		for @i in @start_loop..@end_loop do
			if @cur_page == @i
				@pagination_nav += "<li class = 'selected'>#{@i}</li>"
			else
				@pagination_nav += "<li class='active'><a href = '#{@current_page_url}?pageno=#{@i}'>#{@i}</a></li>"
			end
		end

		if @next_btn && @cur_page < @no_of_paginations
			@nex = @cur_page + 1
			@pagination_nav += "<li class='active'><a href = '#{@current_page_url}?pageno=#{@nex}'>Next</a></li>"
		elsif @next_btn
			@pagination_nav += "<li class='inactive'>Next</li>"
		end

		if @last_btn && @cur_page < @no_of_paginations
			@pagination_nav += "<li class='active'><a href = '#{@current_page_url}?pageno=#{@no_of_paginations}'>Last</a></li>"
		elsif @last_btn
			@pagination_nav += "<li class='inactive'>Last</li>"
		end

		@pagination_nav = "#{@pagination_nav}
				</ul>
			</div>"
		
		@output = "
			<div>#{@pagination_content}</div>
			<div>#{@pagination_nav}</div>
		"
	end
	
	def show
		@article = Article.find(params[:id])
	end
	
	def new
		# Pass the @article variable, which contains errors, to the view: "articles/new"  
		@article = Article.new
	end
	
	def edit
		# Pass the @article variable, which contain the post data, to the view "articles/edit"
		@article = Article.find(params[:id])
	end
	
	def create
		@article = Article.new(article_params)
		
		if @article.save
			redirect_to @article
		else
			# Use same request during form submit to redirect user back to the form 
			# This will call for the function "new" and it passes @article variable containing the errors
			render "new"
		end
	end
	
	def update
		@article = Article.find(params[:id])

		if @article.update(article_params)
			redirect_to @article
		else
			render "edit"
		end
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy

		redirect_to articles_path
	end

	private
		def article_params
			params.require(:article).permit(:title, :text)
		end
end