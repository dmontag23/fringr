class Conflict < ApplicationRecord
  
  belongs_to :contact, optional: true
  belongs_to :location, optional: true

  # Validations
	validates :start_time, presence: true
	validates :end_time, presence: true
	validate :end_time_is_greater_than_start_time
	validate :contact_xor_location

  private

  	def end_time_is_greater_than_start_time
  		if start_time && end_time
  		 errors.add(:end_time, "must be later than the start time") unless start_time < end_time
  		end
  	end

  	def contact_xor_location
      errors.add(:base, "Specify a charge or a payment, not both") unless contact.blank? || location.blank?
    end

end
