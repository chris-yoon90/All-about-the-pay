class Employee < ActiveRecord::Base
	attr_accessor :remember_token

	has_many :group_memberships, dependent: :destroy
	has_many :groups, through: :group_memberships
	has_many :group_ownerships, dependent: :destroy
	has_many :owned_groups, through: :group_ownerships, source: :group

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, presence: true, 
						uniqueness: { case_sensitive: false },
						format: { with: VALID_EMAIL_REGEX }
	before_save do 
		self.email.downcase!
	end

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
	VALID_PASSWORD_REGEX = /\A.*(?=.*[a-z])(?=.*[A-Z])(?=.*[\d\W]).*\z/
	validates :password, length: { minimum: 6 },
						format: { with: VALID_PASSWORD_REGEX }

	validates_confirmation_of :password

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def remember
		self.remember_token = Employee.new_token
		self.update_attribute(:remember_digest, Employee.digest(self.remember_token))
	end

	def forget
		self.update_attribute(:remember_digest, nil)
	end

	def remember_token_authenticated?(remember_token)
		BCrypt::Password.new(self.remember_digest) == remember_token
	end

	def member?(group)
		self.group_memberships.find_by(group_id: group.id)
	end

	def owner?(group)
		self.group_ownerships.find_by(group_id: group.id)
	end

end
