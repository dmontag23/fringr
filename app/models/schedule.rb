class Schedule < ApplicationRecord

	belongs_to :user
	has_many :days, inverse_of: :schedule, dependent: :destroy
	has_many :pieces, dependent: :destroy
	accepts_nested_attributes_for :days, allow_destroy: true 
	default_scope -> { order(created_at: :desc) }

	# validations
	validates :name, presence: true, length: {maximum: 150}
	validates :actor_transition_time, presence: true
	validates_associated :days
	
end
