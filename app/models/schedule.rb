class Schedule < ApplicationRecord

	belongs_to :user
	default_scope -> { order(created_at: :desc) }
	has_many :days, inverse_of: :schedule, dependent: :destroy
	accepts_nested_attributes_for :days, allow_destroy: true 
	has_many :pieces, dependent: :destroy

	# validations
	validates :name, presence: true, length: {maximum: 150}
	validates :actor_transition_time, presence: true
	validates_associated :days
	
end
