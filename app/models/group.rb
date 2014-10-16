class Group < ActiveRecord::Base

	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	has_many :group_memberships, dependent: :destroy
	has_many :members, through: :group_memberships, source: :employee

	def accept_member!(employee)
		self.group_memberships.create!(employee_id: employee.id)
	end

	def reject_member!(employee)
		self.group_memberships.find(employee.id).destroy!
	end

end
