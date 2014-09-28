class Employee < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, presence: true, 
						uniqueness: { case_sensitive: false },
						format: { with: VALID_EMAIL_REGEX }
	before_save { email.downcase! }

	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	validates :position, presence: true, 
						length: { minimum: 2, maximum: 50 }

	has_secure_password


	#length: 6 or more characters
	#At least 1 lowercase letter
	#At least 1 uppercase letter
	#At least 1 special character
	#At least 1 digit
	VALID_PASSWORD_REGEX = /\A.*(?=.*[a-z])(?=.*[A-Z])(?=.*[\W])(?=.*[\d]).*\z/
	validates :password, length: { minimum: 6 },
						format: { with: VALID_PASSWORD_REGEX }

	validates_confirmation_of :password

end
