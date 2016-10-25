class Location < ApplicationRecord
  
  belongs_to :user
	has_many :pieces, dependent: :nullify

  validates :name, presence: true, length: { maximum: 150 }

end
