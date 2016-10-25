class Day < ApplicationRecord
  
  belongs_to :schedule
  has_many :pieces, dependent: :nullify

	# Validations
	validates :start_date, presence: true
	validates :end_date, presence: true
  
end
