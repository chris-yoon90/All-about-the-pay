require 'rails_helper'

RSpec.feature "AuthenticationPages", :type => :feature do
	subject { page }

	shared_examples "all log in pages" do
		it { should have_content('Log in') }
		it { should have_title(full_title('Log in')) }
		it { should have_selector('div.alert.alert-warning', text: "Please sign in")}
	end

	shared_examples "all user pages" do
		it { should have_title(full_title(user.name)) }
	end

	feature "non logged-in users are redirected to log in page" do
		describe "visiting employee index page" do
			before { visit employees_path }
			it_should_behave_like "all log in pages"
		end

		describe "visiting employee show page" do
			before { visit employee_path(FactoryGirl.create(:employee)) }
			it_should_behave_like "all log in pages"
		end

		describe "visiting employee new page" do
			before { visit new_employee_path }
			it_should_behave_like "all log in pages"
		end

		describe "visiting employee edit page" do
			before { visit edit_employee_path(FactoryGirl.create(:employee)) }
			it_should_behave_like "all log in pages"
		end

		describe "returns to previous page after logging in" do
			let(:valid_user) { FactoryGirl.create(:employee) }
			before do
				visit employee_path(valid_user)
				log_in valid_user
			end

			it_should_behave_like 'all user pages' do
				let(:user) { valid_user }
			end
		end
	end

	feature "non-admin users visit new employee creation page" do
		feature "visit employee#new page" do
			feature "for regular employees" do
				let(:regular_employee) { FactoryGirl.create(:employee) }
				before do 
					log_in regular_employee
					visit new_employee_path 
				end

				it_should_behave_like 'all user pages' do
					let(:user) { regular_employee }
				end
			end

			feature "for managers" do
				let(:manager) { FactoryGirl.create(:manager) }
				before do 
					log_in manager
					visit new_employee_path 
				end

				it_should_behave_like 'all user pages' do
					let(:user) { manager }
				end
			end
		end

		feature "visit employee#index page" do
			feature "for regular employees" do
				let(:regular_employee) { FactoryGirl.create(:employee) }
				before do
					log_in regular_employee
					visit employees_path
				end

				it_should_behave_like 'all user pages' do
					let(:user) { regular_employee }
				end
			end
		end

	end
end