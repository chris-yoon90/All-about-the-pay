require 'rails_helper'

RSpec.feature "SessionsPages", :type => :feature do
  subject { page }

  feature "log in page" do
  	before { visit login_path }

  	it { should have_title(full_title("Log in")) }
  	it { should have_selector('h2', text: "Log in") }
  	it { should have_submit_button("Log in") }
    it { should have_text("Email") }
    it { should have_text("Password") }
    it { should have_text("Remember me") }

  	feature "log in" do

  		feature "with valid user" do
  			let(:valid_employee) { FactoryGirl.create(:employee) }
  			before do
  				fill_in "Email", with: valid_employee.email
  				fill_in "Password", with: valid_employee.password
  				click_button "Log in"
  			end
  			
  			it { should have_title(full_title(valid_employee.name)) }
  			it { should_not have_link "Log in" }
  			it { should have_link "Log out" }

        feature "log out" do
          before { click_link "Log out" }

          it { should have_title(full_title("Log in")) }
          it { should_not have_link "Log out" }
          it { should have_link "Log in" }
        end

  		end

  		feature "with invalid user" do
  			before { click_button "Log in" }

  			it { should have_title(full_title("Log in")) }
  			it { should have_error_message("Invalid email or password.") }
        scenario "error message should disappear after refreshing the login page" do
          visit login_path
          expect(page).to_not have_error_message("Invalid email or password.")
        end
  		end
  	end

  end

end
