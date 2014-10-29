class GroupOwnershipsController < ApplicationController
	def create
	end

	def destroy
		group_ownership = GroupOwnership.find(params[:id])
  		group = group_ownership.group
  		group.reject_owner!
  		redirect_to group_path(group)
	end
end
