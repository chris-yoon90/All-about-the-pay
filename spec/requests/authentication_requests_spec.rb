require 'rails_helper'

RSpec.describe "AuthenticationRequests", :type => :request do
	describe "non-logged in users" do
		describe "cannot send POST request to employee#create" do
			before { post employees_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "cannot send PUT/PATCH request to employee#update" do
			before { patch employee_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "cannot send DELETE request to employee#destroy" do
			before { delete employee_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end
	end

	describe "non-admin users" do
		describe "regular employees cannot send POST request to employee#create" do
			let(:regular_employee) { FactoryGirl.create(:employee) }
			before do 
				log_in(regular_employee, no_capybara: true)
				post employees_path
			end
			specify { expect(response).to redirect_to(employee_path(regular_employee)) }
		end

		describe "managers cannot send DELETE request to employee#destroy" do
			let(:manager) { FactoryGirl.create(:manager) }
			before do
				log_in(manager, no_capybara: true)
				delete employee_path(1)
			end
			specify { expect(response).to redirect_to(employee_path(manager)) }
		end

		describe "regular employees cannot send PATCH request to update other user's info" do
			let(:employee1) { FactoryGirl.create(:employee) }
			let(:employee2) { FactoryGirl.create(:employee) }
			before do
				log_in(employee1, no_capybara: true)
				patch employee_path(employee2)
			end
			specify { expect(response).to redirect_to(employee_path(employee1)) }
		end

		describe "managers cannot send PATCH request to update other user's info" do
			let(:manager) { FactoryGirl.create(:manager) }
			let(:employee) { FactoryGirl.create(:employee) }
			before do
				log_in(manager, no_capybara: true)
				patch employee_path(employee)
			end
			specify { expect(response).to redirect_to(employee_path(manager)) }
		end

	end

end
