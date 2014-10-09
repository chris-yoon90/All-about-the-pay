class EmployeesController < ApplicationController
	before_action :non_logged_in_user_redirect
	before_action :non_site_admin_users_redirect, only: [ :new, :create, :destroy ]
	before_action :regular_employee_users_redirect, only: [ :index ]

	def index
		# @employees = Employee.paginate(page: params[:page])
	end

	def show
		@employee = Employee.find(params[:id])
	end

	def new
		@employee = Employee.new
	end

	def create
		@employee = Employee.new(employee_params_create)
		if @employee.save
			redirect_to @employee
		else
			render 'new'
		end
	end

	def edit
		# @employee = Employee.find(params[:id])
	end

	def update
		# @employee = Employee.find(params[:id])
		# if @employee.update(employee_params)
		# 	redirect_to @employee
		# else
		# 	render 'edit'
		# end
	end

	def destroy
	end

	private
		def employee_params_create
			params_for_employee = params.require(:employee)
			params_for_employee[:password] ||= generate_password
			params_for_employee[:password_confirmation] = params_for_employee[:password]
			params_for_employee.permit(:name, :email, :position, :access_level, :password, :password_confirmation)
		end

		def generate_password
			SecureRandom.urlsafe_base64
		end

		def non_site_admin_users_redirect
			unless current_user.is_site_admin
				redirect_to current_user
			end
		end

		def regular_employee_users_redirect
			redirect_to current_user if current_user.is_regular_employee
		end
	
end