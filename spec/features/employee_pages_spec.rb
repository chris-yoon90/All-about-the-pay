require 'rails_helper'

RSpec.feature "EmployeePages", :type => :feature do
	subject { page }

	feature "Visit Employee#index page" do
		feature "As an admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				20.times { FactoryGirl.create(:employee) }
				log_in admin
				visit employees_path
			end

			it { should have_content "Employee Index" }
			it { should have_link('Create New Employee', href: new_employee_path) }
			it { should_not have_link('delete', href: employee_path(admin)) }
			it "should list 10 users on the first page" do
				Employee.paginate(page: 1).each do |item|
					should have_link(item.name, href: employee_path(item)) 
					should have_link('edit', href: edit_employee_path(item)) 
					should have_content(item.position)
				end
			end

			feature "Click 'delete' button" do
				it { expect { click_link('delete', match: :first) }.to change(Employee, :count).by(-1) }

				feature "Success message is shown" do
					before { click_link('delete', match: :first) }
					it { should have_success_message("deleted") }
				end
			end

		end

		feature "As a non admin user but a group owner" do
			let(:user) { FactoryGirl.create(:employee) }
			let(:group1) { FactoryGirl.create(:group) }
			let(:group2) { FactoryGirl.create(:group) }
			before do
				group1.accept_owner!(user)
				group2.accept_owner!(user)
				10.times { group1.accept_member!(FactoryGirl.create(:employee)) }
				10.times { group2.accept_member!(FactoryGirl.create(:employee)) }
				log_in user
				visit employees_path
			end

			it { should have_text "Employee Index" }
			it { should_not have_link('Create new employee') }

			it "should list all subordinates" do
				user.subordinates.paginate(page: 1).each do |item|
					should have_link(item.name, href: employee_path(item)) 
					should_not have_link('edit', href: edit_employee_path(item))
					should_not have_link('delete', href: employee_path(item)) 
				end
			end

		end

	end

	feature "Visit Employee#new page as an admin user" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do 
			log_in admin
			visit new_employee_path 
		end

		it { should have_title(full_title('New Employee')) }
		it { should have_content("New Employee") }
		it { should have_content('Name') }
		it { should have_content('Email') }
		it { should have_content('Position') }
		it { should have_submit_button("Sign 'em up!") }


		feature "And create new user" do
			feature "With invalid information" do
				let(:submit) { "Sign 'em up!" }

				scenario "Employee count should not change" do
					expect { click_button submit }.not_to change(Employee, :count)
				end

				feature "The page has" do
					before { click_button submit }
					it { should have_title(full_title('New Employee')) }
					it { should have_error_message("error") }
				end
			end

			feature "With valid information" do
				let(:submit) { "Sign 'em up!" }
				let(:employee) { FactoryGirl.build(:employee) }

				before do
					fill_in "Name", with: employee.name
					fill_in "Email", with: employee.email
					fill_in "Position", with: employee.position
				end

				it "Should create a new user" do
					expect { click_button submit }.to change(Employee, :count).by(1)
				end
				
			end
		end
	end

	feature "Visit Employee#edit page" do
		feature "As a non-site-admin user" do
			let(:employee) { FactoryGirl.create(:employee) }
			before do
				log_in employee
				visit edit_employee_path(employee)
			end

			it { should have_title(full_title("Edit #{employee.name}")) }
			it { should have_content(employee.name) }
			it { should have_content("Password") }
			it { should have_content("Password confirmation")}
			it { should_not have_content("Name") }
			it { should_not have_content("Email") }
			it { should_not have_content("Position") }

			feature "Update the user information" do
				feature "With invalid information" do
					before do
						click_button "Update"
					end

					specify { expect(employee.reload.authenticate(employee.password)).not_to be_falsey }
					it { should have_title(full_title("Edit #{employee.name}")) }
					it { should have_error_message("error") }
				end

				feature "With valid information" do
					let(:new_password) { "eR34Fff" }
					before do
						fill_in "Password", with: new_password
						fill_in "Password confirmation", with: new_password
						click_button "Update"
					end

					specify { expect(employee.reload.authenticate(new_password)).to be_truthy }
					it { should have_success_message("success") }
					it { should have_title(full_title(employee.name)) }

				end

			end

		end

		feature "As a site admin" do

			let(:admin) { FactoryGirl.create(:admin) }
			before { log_in admin }

			feature "Visit current user's Employee#edit page" do
				before { visit edit_employee_path(admin) }

				it { should have_title(full_title("Edit #{admin.name}")) }
				it { should have_content(admin.name) }
				it { should have_content("Password") }
				it { should have_content("Password confirmation")}
				it { should have_content("Name") }
				it { should have_content("Email") }
				it { should have_content("Position") }

				feature "Update the current user information" do
					feature "With invalid information" do
						before { click_button "Update" }
						specify { expect(admin.reload.authenticate(admin.password)).to be_truthy }
						it { should have_title(full_title("Edit #{admin.name}")) }
						it { should have_error_message("error") }
					end

					feature "With valid information" do
						let(:new_name) { "Updating Test Admin" }
						before do 
							fill_in "Name", with: new_name
							fill_in "Password", with: admin.password
							fill_in "Password confirmation", with: admin.password_confirmation
							click_button "Update"
						end

						it { expect(admin.reload.name).to eq new_name }
						it { should_not have_error_message("error") }
						it { should have_success_message("success") }
						it { should have_title(full_title(new_name)) }

					end

				end

			end

			feature "Visit other user's Employee#edit page" do
				let(:employee) { FactoryGirl.create(:employee) }
				before do
					visit edit_employee_path(employee)
				end

				it { should have_title(full_title("Edit #{employee.name}")) }
				it { should have_content(employee.name) }
				it { should_not have_content("Password") }
				it { should_not have_content("Password confirmation")}
				it { should have_content("Name") }
				it { should have_content("Email") }
				it { should have_content("Position") }

				feature "Update the other user's information" do
					let(:new_name) { "This Employee got promoted" }
					before do
						fill_in "Name", with: new_name
						click_button "Update"
					end

					specify { expect(employee.reload.authenticate(employee.password)).to be_falsey }
					it { expect(employee.reload.name).to eq new_name }
					it { should have_title(full_title(new_name)) }
					it { should_not have_error_message("error") }
					it { should have_success_message("success") }
					
				end

			end
		end
	end

end
