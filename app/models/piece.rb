class Piece < ApplicationRecord
  
	belongs_to :schedule
	belongs_to :day, optional: true
	belongs_to :location, optional: true
	has_many :participants, inverse_of: :piece
	has_many :contacts, through: :participants, dependent: :destroy
	accepts_nested_attributes_for :participants, allow_destroy: true 
	default_scope -> { order(created_at: :desc) }

	# Validations
	validates :title, presence: true, length: { maximum: 150 }
	validates :length, presence: true, numericality: {greater_than_or_equal_to: 1}
	validates :setup, presence: true, numericality: {greater_than_or_equal_to: 1}
	validates :cleanup, presence: true, numericality: {greater_than_or_equal_to: 1}
	validates :rating, presence: true
  validates_inclusion_of :rating, :in => (1..4)

end
