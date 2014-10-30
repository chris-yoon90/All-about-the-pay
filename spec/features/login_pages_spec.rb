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

  shared_examples "Header after login" do
    it { should_not have_link "Log in" }
    it { should have_link "Log out" }
    it { should have_link "Edit Account Info" }
    it { should have_link 'Account' }
    it { should have_link 'Edit Account Info' }
    it { should have_link 'Time Sheet'}
  end

  shared_examples "Header after logout" do
    it { should have_title(full_title("Log in")) }
    it { should_not have_link "Log out" }
    it { should_not have_link "Account" }
    it { should_not have_link "Edit Account Info" }
    it { should have_link "Log in" }
  end

  feature "Visit log in page" do
  	before { visit login_path }

    it_should_behave_like "Log in page"

  	feature "Log in" do

  		feature "With valid user" do

        feature "As a non-admin user" do
    			let(:valid_employee) { FactoryGirl.create(:employee) }
    			before do
    				fill_in "Email", with: valid_employee.email
    				fill_in "Password", with: valid_employee.password
    				click_button "Log in"
    			end
    			
    			it { should have_title(full_title(valid_employee.name)) }
    			it_should_behave_like "Header after login"
          it { should_not have_link "Subordinates" }
          it { should_not have_link "Your Groups" }

          feature "If the user has subordinates" do
            let(:group) { FactoryGirl.create(:group) }
            let(:subordinate) { FactoryGirl.create(:employee) }
            before do
              group.accept_owner!(valid_employee)
              group.accept_member!(subordinate)
              visit root_path #to refresh the page
            end

            it { should have_link "Subordinates", href: subordinates_employee_path(valid_employee) }
            it { should have_link "Your Groups" }

          end

          feature "And log out right after" do
            before { click_link "Log out" }
            it_should_behave_like "Header after logout"
          end
        end

        feature "As an admin user" do
          let(:admin) { FactoryGirl.create(:admin) }
          before do
            fill_in "Email", with: admin.email
            fill_in "Password", with: admin.password
            click_button "Log in"
          end

          it { should have_title(full_title(admin.name)) }
          it_should_behave_like "Header after login"
          it { should have_link 'Employee Index', href: employees_path }
          it { should have_link 'Create New Employee', href: new_employee_path }
          it { should have_link 'Group Index', href: groups_path }
          it { should have_link 'Create New Group', href: new_group_path }

          feature "And log out right after" do
            before { click_link "Log out" }

            it_should_behave_like "Header after logout"
            it { should_not have_link 'Employees' }
            it { should_not have_link 'Groups' }
          end

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
