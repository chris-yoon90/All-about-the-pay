class Group < ActiveRecord::Base

	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	has_many :group_memberships, dependent: :destroy
	has_many :members, through: :group_memberships, source: :employee
	has_one :group_ownership, dependent: :destroy
	has_one :owner, through: :group_ownership, source: :employee

	def accept_member!(employee)
		self.group_memberships.create!(employee_id: employee.id)
	end

	def reject_member!(employee)
		self.group_memberships.find(employee.id).destroy!
	end

	def accept_owner!(owner)
		self.create_group_ownership!(employee_id: owner.id)
	end

	def reject_owner!
		self.group_ownership.destroy!
	end

end
