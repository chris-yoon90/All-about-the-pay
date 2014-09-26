require 'rails_helper'

RSpec.feature "EmployeePages", :type => :feature do
	subject { page }

	feature "new employee creation page" do
		before { visit new_employee_path }

		it { should have_title(full_title('New Employee')) }
		it { should have_selector('h2', text: "New Employee Information") }

		it { should have_submit_button("Sign 'em up!") }
	end

end
