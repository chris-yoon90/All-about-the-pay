class EmployeesController < ApplicationController
	before_action :non_logged_in_user_must_log_in
	before_action :only_site_admin_has_access, only: [ :new, :create, :destroy ]
	before_action :only_site_admin_has_access_to_other_users_page, only: [ :edit, :update ]
	before_action :regular_employee_users_only_have_access_to_their_own_page, only: [ :show ]

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
		password = generate_password #Should send it to the user automatically
		@employee = Employee.new(employee_params(password))
		if @employee.save
			flash[:success] = "New employee is created!"
			redirect_to @employee
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		new_password = generate_password #Should send it to the user automatically
		if @employee.update(employee_params_update(new_password))
			flash[:success] = "Information of #{@employee.name} is updated successfully!"
			redirect_to @employee
		else
			render 'edit'
		end
	end

	def destroy
	end

	private
		def employee_params(password)
			params_for_employee = params.require(:employee)
			params_for_employee[:password] = password
			params_for_employee[:password_confirmation] = password
			params_for_employee.permit(:name, :email, :position, :access_level, :password, :password_confirmation)
		end

		def employee_params_update(new_password)
			if current_user.is_regular_employee?
				return params.require(:employee).permit(:password, :password_confirmation)
			elsif current_user.is_site_admin?
				return params.require(:employee).permit(:name, :email, :position, :access_level, :password, :password_confirmation) if @employee == current_user
				return employee_params(new_password)
			end
		end

		def generate_password
			SecureRandom.urlsafe_base64
		end

		def only_site_admin_has_access
			unless current_user.is_site_admin?
				redirect_to current_user
			end
		end

		def only_site_admin_has_access_to_other_users_page
			@employee = Employee.find(params[:id])
			unless current_user.is_site_admin?
				redirect_to current_user if current_user != @employee
			end
		end

		def regular_employee_users_only_have_access_to_their_own_page
			@employee = Employee.find(params[:id])
			if current_user.is_regular_employee?
				redirect_to current_user if current_user != @employee
			end
		end
	
end