class Schedule < ApplicationRecord

	belongs_to :user
	has_many :days,   dependent: :destroy
	has_many :pieces, dependent: :destroy
	
end
