class Piece < ApplicationRecord
  
	belongs_to :schedule
	belongs_to :day, optional: true
	belongs_to :location, optional: true
	has_many :participants
	has_many :contacts, through: :participants, dependent: :destroy

end
