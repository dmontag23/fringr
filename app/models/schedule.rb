class Schedule < ApplicationRecord

	belongs_to :user
	has_many :days,   dependent: :destroy
	has_many :pieces, dependent: :destroy

	# validations
	validates :name, presence: true, length: {maximum: 150}
	validates :actor_transition_time, presence: true
	
end
