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
		it { should have_content "Name" }
		it { should have_submit_button("Create a new group") }

		feature "And create a user" do
			let(:submit) { "Create a new group" }

			feature "With invalid information" do

				it "group count should not be changed" do
					expect{ click_button submit }.not_to change(Group, :count)
				end

				feature "The page has" do
					before { click_button submit }
					it { should have_title(full_title('New Group')) }
					it { should have_error_message("error") }
				end

			end

			feature "With valid information" do
				let(:name) { "Valid Group Name" }

				before do
					fill_in "Name", with: name 
				end

				it "should create a new user" do
					expect{ click_button submit }.to change(Group, :count).by(1)
				end

				feature "redirected to Group#show page" do
					before { click_button submit }
					it { should have_title(full_title(name)) }
					it { should have_success_message("New group is created!") }
				end

			end

		end

	end

	feature "Visit Group#show page as an admin" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:group) { FactoryGirl.create(:group) }
		before do
			20.times { group.accept_member!(FactoryGirl.create(:employee)) }
			log_in admin
			visit group_path(group)
		end

		it { should have_title(full_title(group.name)) }
		it { should have_content(group.name) }
		it { should have_content("No Owner") }
		it { should have_link "Choose an owner", href: search_owner_group_path(group) }

		feature "Shows group owner if it exists" do
			let(:group_owner) { FactoryGirl.create(:employee) }
			before do
				group.accept_owner!(group_owner)
				visit group_path(group)
			end

			it { should have_link(group_owner.name, href: employee_path(group_owner)) }
			it { should have_link('edit', href: edit_employee_path(group_owner)) }
			it { should have_link('remove ownership', href: group_ownership_path(group.group_ownership)) }
			it { should have_content(group_owner.position)}
			it { should have_content("Group Owner") }

			feature "Click 'remove ownerhip' to remove the owner from the group" do
				before { click_link "remove ownership" }

				it { expect(group.owner).to be_nil }
			end

		end

		it "shows all group members" do
			group.members.paginate(page: 1).each do |member|
				should have_link(member.name, href: employee_path(member)) 
				should have_link('edit', href: edit_employee_path(member)) 
				should have_link('remove from group', href: group_membership_path(group.group_memberships.find_by(employee_id: member.id)))
				should have_content(member.position)
			end
		end

		feature "Remove a member from the group" do
			let!(:member_count) { group.members.count }

			before { click_link "remove from group", match: :first }

			it { expect(group.members.count).to eq member_count-1 }

		end

	end

	feature "Visit Group#index page as an admin" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do
			20.times { FactoryGirl.create(:group) }
			log_in admin
			visit groups_path
		end

		it { should have_content "Group Index" }
		it { should have_title(full_title("Groups")) }
		it "shows all groups" do
			Group.paginate(page: 1).each do |group|
				should have_link group.name, href: group_path(group)
				should have_link 'edit', href: edit_group_path(group)
				should have_link 'delete', href: group_path(group)
				should have_text "#{group.members.count} #{'member'.pluralize(group.members.count)}"
			end
		end

		feature "Click delete link" do
			it { expect { click_link('delete', match: :first) }.to change(Group, :count).by(-1) }
			feature "Success message is shown" do
				before { click_link('delete', match: :first) }
				it { should have_success_message("deleted") }
				it { should have_title(full_title("Groups")) }
			end
		end

	end

	feature "Visit Group#edit page as an admin" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:group) { FactoryGirl.create(:group) }
		before do
			log_in admin
			visit edit_group_path(group)
		end

		it { should have_title(full_title("Edit #{group.name}")) }
		it { should have_content("Name") }
		it { should have_submit_button("Update") }

		feature "Update with invalid information" do
			let(:name) { group.name }
			before do
				fill_in "Name", with: " "
				click_button "Update"
			end

			it { should have_error_message("error") }
			it { should have_title(full_title("Edit")) }
			it { expect(group.reload.name).to eq name }
		end

		feature "Update with valid information" do
			let(:new_name) { "New Name" }
			before do
				fill_in "Name", with: new_name
				click_button "Update"
			end

			it { expect(group.reload.name).to eq new_name }
			it { have_title(full_title(new_name)) }
			it { have_text(new_name) }

		end

	end

	feature "Visit Groups#search_owner page as an admin" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:group) { FactoryGirl.create(:group) }
		before do
			log_in admin
			visit search_owner_group_path(group)
		end

		it { should have_selector('input#search_employees') }

		it "Should have a list of all Employees" do
			Employee.paginate(page: 1).each do |employee|
				should have_text(employee.name) 
				should have_text(employee.position)
				should have_selector("form#new_group_ownership_#{employee.id}")
			end
		end

		feature "Click 'Choose as an owner' to assign a group ownership to an employee" do
			before do
				click_button "Choose as an owner", match: :first
			end

			it { expect(group.owner.id).to eq admin.id }

			it { should have_title(full_title("#{group.name}")) }
			it { should have_content(group.name) }

		end

	end

end
