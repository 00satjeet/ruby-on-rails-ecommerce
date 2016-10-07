class ArticlesController < ApplicationController
	def index
		@articles = Article.all
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
			render 'new'
		end
	end
	
	def update
		@article = Article.find(params[:id])

		if @article.update(article_params)
			redirect_to @article
		else
			render 'edit'
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
