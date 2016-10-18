class User < ApplicationRecord
  before_save { email.downcase! } # change all submitted emails to downcase

  # validations
	validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
	                  format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }             
	has_secure_password # enforce validations on virtual password and password_confirmation attributes from bycrypt
	validates :password, presence: true

end
