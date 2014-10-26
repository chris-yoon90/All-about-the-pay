class GroupsController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def new
  	@group = Group.new
  end

  def create
  	@group = Group.new(group_params)
  	if @group.save

  	else
  		render 'new'
  	end
  end

  private
  	def group_params
  		params.require(:group).permit(:name)
  	end

end
