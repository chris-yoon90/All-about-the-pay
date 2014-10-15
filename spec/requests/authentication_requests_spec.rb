require 'rails_helper'

RSpec.describe "AuthenticationRequests", :type => :request do
	describe "As a non-logged in user" do
		describe "Send a POST request to Employee#create" do
			before { post employees_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send PUT/PATCH request to Employee#update" do
			before { patch employee_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send DELETE request to Employee#destroy" do
			before { delete employee_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send GET request to Employee#index" do
			before { get employees_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send GET request to Employee#show" do
			before { get employee_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send GET request to Employee#new" do
			before { get new_employee_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send GET request to Employee#edit" do
			before { get edit_employee_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

	end

	describe "As a non-admin user" do

		describe "As a manager (access level B)" do
			let(:manager) { FactoryGirl.create(:manager) }
			before { log_in manager, no_capybara: true }

			describe "Send GET request to other user's Employee#edit" do
				let(:manager2) { FactoryGirl.create(:manager) }
				before { get edit_employee_path(manager2) }
				specify { expect(response).to redirect_to(employee_path(manager)) }
			end

			describe "Send GET request to Employee#new" do
				before { get new_employee_path }
				specify { expect(response).to redirect_to(employee_path(manager)) }
			end

			describe "Send DELETE request to Employee#destroy" do
				before { delete employee_path(1) }
				specify { expect(response).to redirect_to(employee_path(manager)) }
			end

			describe "Send POST request to Employee#create" do
				before { post employees_path }
				specify { expect(response).to redirect_to(employee_path(manager)) }
			end

			describe "Send PATCH request to other user's Employee#update" do
				let(:employee) { FactoryGirl.create(:employee) }
				before { patch employee_path(employee) }
				specify { expect(response).to redirect_to(employee_path(manager)) }
			end

			describe "Send PATCH request to Employee#update to update information other than password" do
				let(:employee) { FactoryGirl.create(:employee) }
				let(:new_name) { "Name does not update" }
				let(:new_email) { "doesnotupdate@doesnotupdate.com" }
				let(:new_position) { "Position Does not update" }
				before do
					patch employee_path(employee), 
							employee: { 
								name: new_name, 
								email: new_email,
								position: new_position,
								password: employee.password, 
								password_confirmation: employee.password 
							}
				end

				specify { expect(employee.reload.name).to_not eq new_name }
				specify { expect(employee.reload.email).to_not eq new_email }
				specify { expect(employee.reload.position).to_not eq new_position }
			end

		end

		describe "As a employee (access level A)" do
			let(:employee) { FactoryGirl.create(:employee) }
			before { log_in(employee, no_capybara: true) }

			describe "Send GET request to other user's Employee#edit" do
				let(:employee2) { FactoryGirl.create(:employee) }
				before { get edit_employee_path(employee2) }
				specify { expect(response).to redirect_to(employee_path(employee)) }
			end

			describe "Send GET request to other user's Employee#show" do
				let(:employee2) { FactoryGirl.create(:employee) }
				before { get employee_path(employee2) }
				specify { expect(response).to redirect_to(employee_path(employee)) }
			end

			describe "Send GET request to Employee#new" do
				before { get new_employee_path }
				specify { expect(response).to redirect_to(employee_path(employee)) }
			end

			describe "Send DELETE request to employee#destroy" do
				before { delete employee_path(1) }
				specify { expect(response).to redirect_to(employee_path(employee)) }
			end

			describe "Send POST request to employee#create" do
				before { post employees_path }
				specify { expect(response).to redirect_to(employee_path(employee)) }
			end

			describe "Send PATCH request to update other user's info" do
				let(:employee2) { FactoryGirl.create(:employee) }
				before { patch employee_path(employee2) }
				specify { expect(response).to redirect_to(employee_path(employee)) }
			end

			describe "Send PATCH request to update information other than password" do
				let(:new_name) { "Name does not update" }
				let(:new_email) { "doesnotupdate@doesnotupdate.com" }
				let(:new_position) { "Position Does not update" }
				before do
					patch employee_path(employee), 
							employee: { 
								name: new_name, 
								email: new_email,
								position: new_position,
								password: employee.password, 
								password_confirmation: employee.password 
							}
				end

				specify { expect(employee.reload.name).to_not eq new_name }
				specify { expect(employee.reload.email).to_not eq new_email }
				specify { expect(employee.reload.position).to_not eq new_position }
			end

		end

	end

end
