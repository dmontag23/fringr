class Participant < ApplicationRecord
  
  belongs_to :contact
  belongs_to :piece

end
