class GroupsController < ApplicationController
  def index
  	@groups = Group.paginate(page: params[:page])
  end

  def show
  	@group = Group.find(params[:id])
  	@members = @group.members.paginate(page: params[:page])
  end

  def edit
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

  private
  	def group_params
  		params.require(:group).permit(:name)
  	end

end
