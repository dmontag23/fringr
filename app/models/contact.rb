class Contact < ApplicationRecord
  
  belongs_to :user
	has_many :participants
	has_many :pieces, through: :participants, dependent: :destroy
	has_many :conflicts, dependent: :destroy

  before_save   :downcase_email

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
	                  format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false, scope: :user, message: "is already taken" }

end
