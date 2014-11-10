class EmployeesController < ApplicationController
	before_action :non_logged_in_user_must_log_in
	before_action :only_site_admin_can_access, only: [ :index, :new, :create, :destroy ]
	before_action :only_site_admin_can_update_other_users, only: [ :edit, :update ]
	before_action :only_site_admin_or_group_owner_can_access, only: [ :show ]
	before_action :only_group_owner_can_access, only: [ :subordinates, :owned_groups ]

	def index
		@employees = Employee.paginate(page: params[:page])
	end

	def show
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
		if @employee.update_attributes(employee_params_update(new_password))
			flash[:success] = "Update is successful!"
			redirect_to @employee
		else
			render 'edit'
		end
	end

	def destroy
		employee = Employee.find(params[:id])
		unless current_user?(employee)
			deleted_user = employee.destroy
			flash[:success] = "Employee '#{deleted_user.name}' has been deleted."
		end
		redirect_to employees_path
	end

	def subordinates
		@employees = @user.subordinates.paginate(page: params[:page])
		render 'show_subordinates'
	end

	def owned_groups
		@owned_groups = @user.owned_groups.paginate(page: params[:page])
		render 'show_owned_groups'
	end

	private
		def employee_params(password)
			params_for_employee = params.require(:employee)
			params_for_employee[:password] = password
			params_for_employee[:password_confirmation] = password
			params_for_employee.permit(:name, :email, :position, :password, :password_confirmation)
		end

		def employee_params_update(new_password)
			if current_user.isAdmin?
				return params.require(:employee).permit(:name, :email, :position, :password, :password_confirmation) if @employee == current_user
				return employee_params(new_password)
			end
			return params.require(:employee).permit(:password, :password_confirmation)
		end

		def generate_password(length = 10)
			temp_string = SecureRandom.urlsafe_base64(length)
			unless temp_string.match(Employee::VALID_PASSWORD_REGEX)
				return generate_password(length)
			end
			return temp_string
		end

		def only_site_admin_can_update_other_users
			@employee = Employee.find(params[:id])
			unless current_user.isAdmin?
				redirect_to current_user unless current_user?(@employee)
			end
		end

		def only_site_admin_or_group_owner_can_access
			@employee = Employee.find(params[:id])
			unless current_user.isAdmin? || current_user?(@employee) || current_user.subordinates.include?(@employee)
				redirect_to current_user
			end
		end

		def only_group_owner_can_access
			@user = Employee.find(params[:id])
			unless current_user?(@user) && @user.is_group_owner?
				redirect_to current_user
			end
		end
	
end