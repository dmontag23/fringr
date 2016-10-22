class ApplicationRecord < ActiveRecord::Base
  
  self.abstract_class = true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end
  
end
