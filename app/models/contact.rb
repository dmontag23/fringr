class Contact < ApplicationRecord
  
  belongs_to :user

  before_save   :downcase_email

  validates :user_id, presence: true
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
	                  format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }  

end
