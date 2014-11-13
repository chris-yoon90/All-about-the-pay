class ActivitiesController < ApplicationController
	
	def index
	end

	def new
		@activity = Activity.new
	end

	def create
		@activity = Activity.new(activity_params)
		if @activity.save
			flash[:success] = "New activity is created!"
  			redirect_to activities_path
		else
			render 'new'
		end
	end

	def delete

	end

	def edit
		@activity = Activity.find(params[:id])
	end

	def update
		@activity = Activity.find(params[:id])
		if @activity.update_attributes(activity_params)
			flash[:success] = "Update is successful!"
			redirect_to activities_path
		else
			render 'edit'
		end
	end

	private
		def activity_params
			params.require(:activity).permit(:name)
		end

end
