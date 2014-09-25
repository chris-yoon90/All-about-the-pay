class Employee < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, presence: true, 
						uniqueness: { case_sensitive: false },
						format: { with: VALID_EMAIL_REGEX }

	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	validates :position, presence: true, 
						length: { minimum: 2, maximum: 50 }

end
