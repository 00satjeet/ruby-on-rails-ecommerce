class User
	include Mongoid::Document
	include ActiveModel::SecurePassword
	
	field :first_name, type: String
	field :last_name, type: String
	field :phone_number, type: String
	field :email, type: String
	field :password_digest, type: String
	field :about_me, type: String
	
	has_secure_password
	
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email, presence: true
end