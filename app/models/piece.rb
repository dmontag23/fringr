class Piece < ApplicationRecord
  
	belongs_to :schedule
	belongs_to :location, optional: true
	has_many :scheduled_times, inverse_of: :piece, dependent: :destroy
	has_many :participants, inverse_of: :piece, dependent: :destroy
	has_many :contacts, through: :participants
	accepts_nested_attributes_for :scheduled_times
	default_scope -> { order(created_at: :desc) }
	attr_accessor :mycount

	# Validations
	validates :title, presence: true, length: { maximum: 150 }
	validates :length, presence: true, numericality: {greater_than_or_equal_to: 1}
	validates :setup, presence: true, numericality: {greater_than_or_equal_to: 1}
	validates :cleanup, presence: true, numericality: {greater_than_or_equal_to: 1}
	validates :rating, presence: true
  validates_inclusion_of :rating, :in => (1..4)
  validates_presence_of :scheduled_times

end
