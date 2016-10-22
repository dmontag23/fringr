class Location < ApplicationRecord
  
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 150 }

end
