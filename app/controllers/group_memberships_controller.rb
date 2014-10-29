class GroupMembershipsController < ApplicationController
  def create
  end

  def destroy
  	group_membership = GroupMembership.find(params[:id])
  	group = group_membership.group
  	employee = group_membership.employee
  	group.reject_member!(employee)
  	redirect_to group_path(group)
  end
end
