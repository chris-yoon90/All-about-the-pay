class GroupOwnershipsController < ApplicationController
	def create
		@owner = Employee.find(params[:group_ownership][:employee_id])
		@group = Group.find(params[:group_ownership][:group_id])
		@group.accept_owner!(@owner)
		redirect_to @group
	end

	def destroy
		group_ownership = GroupOwnership.find(params[:id])
  		group = group_ownership.group
  		group.reject_owner!
  		redirect_to group_path(group)
	end
end
