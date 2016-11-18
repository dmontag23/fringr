class Day < ApplicationRecord
  
  belongs_to :schedule
  has_many :pieces, dependent: :nullify

	# Validations
	validates :start_date, presence: true
	validates :end_date, presence: true
	validate :end_date_is_greater_than_start_date

  private

  	def end_date_is_greater_than_start_date
  		if start_date && end_date 
  		 errors.add(:end_date, "must be later than the start date") unless start_date < end_date
  		end
  	end
  
end
