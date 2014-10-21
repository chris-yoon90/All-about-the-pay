class EmployeesController < ApplicationController
	before_action :non_logged_in_user_must_log_in
	before_action :only_site_admin_can_create_and_destroy_users, only: [ :new, :create, :destroy ]
	before_action :only_site_admin_can_update_other_users, only: [ :edit, :update ]
	before_action :only_site_admin_or_group_owner_can_access_group_member_page, only: [ :show ]
	before_action :only_site_admin_or_group_owner_can_access_user_index, only: [ :index ]

	def index
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
		if @employee.update(employee_params_update(new_password))
			flash[:success] = "Information of #{@employee.name} is updated successfully!"
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

		def generate_password
			SecureRandom.urlsafe_base64
		end

		def only_site_admin_can_create_and_destroy_users
			unless current_user.isAdmin?
				redirect_to current_user
			end
		end

		def only_site_admin_can_update_other_users
			@employee = Employee.find(params[:id])
			unless current_user.isAdmin?
				redirect_to current_user unless current_user?(@employee)
			end
		end

		def only_site_admin_or_group_owner_can_access_group_member_page
			@employee = Employee.find(params[:id])
			unless current_user.isAdmin? || current_user?(@employee)
				owned_groups = current_user.owned_groups
				isMember =false;
				owned_groups.each do |group|
					isMember = true if @employee.member?(group)
				end
				redirect_to current_user unless isMember
			end
		end

		def only_site_admin_or_group_owner_can_access_user_index
			if current_user.isAdmin?
				@employees = Employee.all.paginate(page: params[:page])
			elsif current_user.owned_groups.any?
				@employees = current_user.subordinates.paginate(page: params[:page])
			else
				redirect_to current_user
			end
		end
	
end