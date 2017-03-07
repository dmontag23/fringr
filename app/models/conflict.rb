class Conflict < ApplicationRecord
  
  belongs_to :contact, optional: true
  belongs_to :location, optional: true

  # Validations
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :contact_xor_location
	validate :end_time_is_greater_than_start_time

  private

    # ensures either a contact or a location id is present in the record
    def contact_xor_location
      errors.add(:base, :contact_or_location_blank, message: "either contact or location must be specified, not both") unless contact.blank? ^ location.blank?
    end

  	def end_time_is_greater_than_start_time
  		if start_time && end_time
  		 errors.add(:end_time, "must be later than the start time") unless start_time < end_time
  		end
  	end

end
