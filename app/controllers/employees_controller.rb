class EmployeesController < ApplicationController

	def index
		# @employees = Employee.paginate(page: params[:page])
	end

	def show
		@employee = Employee.find(params[:id])
	end

	def new
		@password = "eB^4kgL"
		@employee = Employee.new
	end

	def create
		@employee = Employee.new(employee_params)
		if @employee.save
			redirect_to @employee
		else
			render 'new'
		end
	end

	def edit
		@employee = Employee.find(params[:id])
	end

	def update
	end

	def destroy
	end

	private
		def employee_params
			params.require(:employee).permit(:name, :email, :position, :password, :password_confirmation)
		end
	
end
