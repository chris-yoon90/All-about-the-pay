require 'rails_helper'

RSpec.feature "EmployeePages", :type => :feature do
	subject { page }

	feature "new employee creation page" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do 
			log_in admin
			visit new_employee_path 
		end

		it { should have_title(full_title('New Employee')) }
		it { should have_selector('h2', text: "New Employee Information") }

		it { should have_submit_button("Sign 'em up!") }


		feature "new employee form" do
			let(:employee) { FactoryGirl.build(:employee) }

			feature "with invalid information" do
				let(:submit) { "Sign 'em up!" }

				scenario "submitting a blank form should not create new user" do
					expect { click_button submit }.not_to change(Employee, :count)
				end

				feature "submitting a form with invalid information" do
					before { click_button submit }
					it { should have_title(full_title('New Employee')) }
					it { should have_error_message("error") }
				end
			end

			feature "with valid information" do
				let(:submit) { "Sign 'em up!" }

				scenario "submitting a form with valid information creates new user" do
					fill_in "Name", with: "Test User"
					fill_in "Email", with: "example@exampleuser.com"
					fill_in "Position", with: "Example User"
					expect { click_button submit }.to change(Employee, :count).by(1)
				end

			end
		end
	end

	feature "edit page" do
		feature "for regular employees" do
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
			it { should_not have_content("Access level") }

			feature "try to update information" do
				feature "with invalid information" do
					before do
						click_button "Update"
					end

					specify { expect(employee.reload.authenticate(employee.password)).not_to be_falsey }
					it { should have_title(full_title("Edit #{employee.name}")) }
					it { should have_error_message("error") }
				end

				feature "with valid information" do
					let(:new_password) { "eR34Fff" }
					before do
						fill_in "Password", with: new_password
						fill_in "Password confirmation", with: new_password
						click_button "Update"
					end

					specify { expect(employee.reload.authenticate(new_password)).to be_truthy }
					it { should have_selector('div.alert.alert-success', text: "success")}
					it { should have_title(full_title(employee.name)) }

				end

			end

		end

		feature "For site admin" do

			let(:admin) { FactoryGirl.create(:admin) }
			before { log_in admin }

			feature "edit it's own user information" do
				before { visit edit_employee_path(admin) }

				it { should have_title(full_title("Edit #{admin.name}")) }
				it { should have_content(admin.name) }
				it { should have_content("Password") }
				it { should have_content("Password confirmation")}
				it { should have_content("Name") }
				it { should have_content("Email") }
				it { should have_content("Position") }
				it { should have_content("Access level") }

				feature "try to update information" do
					feature "with invalid information" do
						before { click_button "Update" }
						specify { expect(admin.reload.authenticate(admin.password)).to be_truthy }
						it { should have_title(full_title("Edit #{admin.name}")) }
						it { should have_error_message("error") }
					end

					feature "with valid information" do
						let(:new_name) { "Updating Test Admin" }
						before do 
							fill_in "Name", with: new_name
							fill_in "Password", with: admin.password
							fill_in "Password confirmation", with: admin.password_confirmation
							click_button "Update"
						end

						it { expect(admin.reload.name).to eq new_name }
						it { should_not have_error_message("error") }
						it { should have_selector('div.alert.alert-success', text: "success")}
						it { should have_title(full_title(new_name)) }

					end

				end

			end

			feature "edit other user information" do
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
				it { should have_content("Access level") }

				feature "try to update information" do
					feature "clicking update without changing any field" do
						before { click_button "Update" }
						specify { expect(employee.reload.authenticate(employee.password)).to be_falsey }
						it { should_not have_error_message("error") }
						it { should have_selector('div.alert.alert-success', text: "success")}
						it { should have_title(full_title(employee.name)) }
					end

					feature "clicking update after changing any field" do
						let(:new_name) { "This Employee got promoted" }
						before do
							fill_in "Name", with: new_name
							click_button "Update"
						end

						it { expect(employee.reload.name).to eq new_name }
						it { should_not have_error_message("error") }
						it { should have_selector('div.alert.alert-success', text: "success")}
						it { should have_title(full_title(new_name)) }
					end

				end

			end
		end
	end

end
