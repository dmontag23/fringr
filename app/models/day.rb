class Day < ApplicationRecord
  
  belongs_to :schedule
  has_many :pieces, dependent: :nullify
  
end
