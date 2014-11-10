class GroupsController < ApplicationController
  before_action :non_logged_in_user_must_log_in
  before_action :only_admin_user_can_access, except: [ :show ]
  before_action :only_admin_user_or_group_owner_can_access, only: [ :show ]

  def index
  	@groups = Group.paginate(page: params[:page])
  end

  def show
  	@group = Group.find(params[:id])
  	@members = @group.members.paginate(page: params[:page])
  end

  def edit
  	@group = Group.find(params[:id])
  end

  def update
  	@group = Group.find(params[:id])
  	if @group.update_attributes(group_params)
  		flash[:success] = "Update is successful!"
  		redirect_to @group
  	else
  		render 'edit'
  	end
  end

  def new
  	@group = Group.new
  end

  def create
  	@group = Group.new(group_params)
  	if @group.save
  		flash[:success] = "New group is created!"
  		redirect_to @group
  	else
  		render 'new'
  	end
  end

  def destroy
  	group = Group.find(params[:id])
  	deleted_group = group.destroy
  	flash[:success] = "Group '#{deleted_group.name}' has been deleted."
  	redirect_to groups_path
  end

  def search_owner
    @group = Group.find(params[:id])
    unless @group.owner
      @employees = Employee.search(params[:search]).paginate(page: params[:page])
      render 'search_owner'
    else
      redirect_to @group
    end
  end

  def search_member
    @group = Group.find(params[:id])
    @employees = Employee.search(params[:search]).paginate(page: params[:page])
    render 'search_member'
  end

  private
  	def group_params
  		params.require(:group).permit(:name)
  	end

    def only_admin_user_can_access
      unless current_user.isAdmin?
        redirect_to current_user
      end
    end

    def only_admin_user_or_group_owner_can_access
      @group = Group.find(params[:id])
      unless current_user.isAdmin? || current_user.owner?(@group)
        redirect_to current_user
      end
    end

end
