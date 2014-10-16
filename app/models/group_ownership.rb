class GroupOwnership < ActiveRecord::Base
  belongs_to :employee
  belongs_to :group

  validates :employee_id, presence: true
  validates :group_id, presence: true
end
