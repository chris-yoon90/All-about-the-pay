require 'rails_helper'

RSpec.feature "EmployeePages", :type => :feature do
	subject { page }

	feature "new employee creation page" do
		before { visit new_employee_path }

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
					it { should have_selector('div.alert.alert-danger') }
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

end
