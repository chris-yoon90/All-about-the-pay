require 'rails_helper'

RSpec.feature "LoginPages", :type => :feature do
  subject { page }

  shared_examples "Log in page" do
    it { should have_title(full_title("Log in")) }
    it { should have_selector('h2', text: "Log in") }
    it { should have_submit_button("Log in") }
    it { should have_content("Email") }
    it { should have_content("Password") }
    it { should have_content("Remember me") }
  end

  feature "Visit log in page" do
  	before { visit login_path }

    it_should_behave_like "Log in page"

  	feature "Log in" do

  		feature "With valid user" do
  			let(:valid_employee) { FactoryGirl.create(:employee) }
  			before do
  				fill_in "Email", with: valid_employee.email
  				fill_in "Password", with: valid_employee.password
  				click_button "Log in"
  			end
  			
  			it { should have_title(full_title(valid_employee.name)) }
  			it { should_not have_link "Log in" }
  			it { should have_link "Log out" }

        feature "And log out right after" do
          before { click_link "Log out" }

          it { should have_title(full_title("Log in")) }
          it { should_not have_link "Log out" }
          it { should have_link "Log in" }
        end

  		end

  		feature "With invalid user" do
  			before { click_button "Log in" }

  			it { should have_title(full_title("Log in")) }
  			it { should have_error_message("Invalid email or password.") }

        feature "And refreshing the login page" do
          before { visit login_path }
          it { should_not have_error_message("Invalid email or password.") }
        end
  		end
  	end

  end

  feature "As a non-logged in user" do
      let(:valid_user) { FactoryGirl.create(:employee) }
      before do
        visit employee_path(valid_user)
      end

      it_should_behave_like "Log in page"

      feature "Then logging in as a valid user" do
        before { log_in valid_user }
        it { should have_title(full_title(valid_user.name)) }
        it { should have_content(valid_user.name) }
      end
    end

end
