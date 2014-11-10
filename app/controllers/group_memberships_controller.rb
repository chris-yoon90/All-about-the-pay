class GroupMembershipsController < ApplicationController
  def create
  	@member = Employee.find(params[:group_membership][:employee_id])
	@group = Group.find(params[:group_membership][:group_id])
	@group.accept_member!(@member)
	redirect_to @group
  end

  def destroy
  	group_membership = GroupMembership.find(params[:id])
  	group = group_membership.group
  	employee = group_membership.employee
  	group.reject_member!(employee)
  	redirect_to group_path(group)
  end
end
