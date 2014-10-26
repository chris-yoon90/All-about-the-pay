require 'rails_helper'

RSpec.feature "GroupPages", :type => :feature do
	subject { page }

	feature "Visit Employee#new page as an admin user" do
		let(:admin) { FactoryGirl.create(:admin) }

		before do 
			log_in admin
			visit new_group_path
		end

		it { should have_content "New Group" }
		it { should have_content "Group Name" }
		it { should have_submit_button("Create a new group") }

		feature "And create a user" do

			feature "With an invalid information" do
				let(:submit) { "Create a new group" }

				it "group count should not be changed" do
					expect{ click_button submit }.not_to change(Group, :count)
				end

				feature "The page has" do
					before { click_button submit }
					it { should have_title(full_title('New Group')) }
					it { should have_error_message("error") }
				end

			end

		end

	end

end
