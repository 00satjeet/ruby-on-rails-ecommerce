class Product
	include Mongoid::Document
	
	field :name, type: String
	field :content, type: String
	field :excerpt, type: String
	field :price, type: Float
	field :status, type: Boolean
	field :quantity, type: Integer
	field :images, type: Array
	field :author, type: BSON::ObjectId
	field :featured_image, type: String
	field :date, type: String
	
	validates :name, presence: true
	validates :price, presence: true
	validates :status, presence: true
	validates :quantity, presence: true
end