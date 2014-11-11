class GroupMembershipsController < ApplicationController
  before_action :non_logged_in_user_must_log_in
  before_action :only_site_admin_can_access

  def create
    member = Employee.find(params[:group_membership][:employee_id])
    @group = Group.find(params[:group_membership][:group_id])
    @group.accept_member!(member)
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
