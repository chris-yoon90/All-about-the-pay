class Group < ActiveRecord::Base

	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	has_many :group_memberships, dependent: :destroy
	has_many :members, through: :group_memberships, source: :employee
	has_one :group_ownership, dependent: :destroy
	has_one :owner, through: :group_ownership, source: :employee

	def accept_member!(employee)
		begin
			self.group_memberships.create!(employee_id: employee.id)
		rescue ActiveRecord::RecordNotUnique
		end
	end

	def reject_member!(employee)
		if membership = self.group_memberships.find_by(employee_id: employee.id)
			membership.destroy!
		end
	end

	def accept_owner!(owner)
		begin
			self.create_group_ownership!(employee_id: owner.id)
		rescue ActiveRecord::RecordNotUnique
		end
	end

	def reject_owner!
		if ownership = self.group_ownership
			ownership.destroy!
		end
	end

end
