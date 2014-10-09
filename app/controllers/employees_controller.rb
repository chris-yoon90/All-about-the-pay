class EmployeesController < ApplicationController
	before_action :non_logged_in_user_must_log_in
	before_action :only_site_admin_has_access, only: [ :new, :create, :destroy ]
	before_action :regular_employee_users_cannot_access, only: [ :index ]
	before_action :regular_employee_users_only_have_access_to_their_own_page, only: [ :show, :edit, :update ]
	before_action :managers_only_have_access_to_their_own_update_page, only: [ :edit, :update ]

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

		def only_site_admin_has_access
			unless current_user.is_site_admin
				redirect_to current_user
			end
		end

		def managers_only_have_access_to_their_own_update_page
			if current_user.is_manager
				@user = Employee.find(params[:id])
				redirect_to current_user if current_user != @user
			end
		end

		def regular_employee_users_only_have_access_to_their_own_page
			if current_user.is_regular_employee
				@user = Employee.find(params[:id])
				redirect_to current_user if current_user != @user
			end
		end

		def regular_employee_users_cannot_access
			redirect_to current_user if current_user.is_regular_employee
		end
	
end