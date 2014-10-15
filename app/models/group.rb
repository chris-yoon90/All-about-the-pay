class Group < ActiveRecord::Base

	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	has_many :group_memberships
	has_many :members, through: :group_memberships, source: :employee

end
