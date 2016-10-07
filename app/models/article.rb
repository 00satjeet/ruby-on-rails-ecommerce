class Article
	include Mongoid::Document
	
	field :title, type: String
	field :text, type: String
	
	validates :title, presence: true, length: { minimum: 5 }
	validates :text, presence: true
end
