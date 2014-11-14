require 'rails_helper'

RSpec.feature "ActivityPages", :type => :feature do
	subject { page }
	let(:admin) { FactoryGirl.create(:admin) }
	before do
		log_in admin
	end

	feature "Visit Activity#index page as an admin" do
		before do 
			20.times { FactoryGirl.create(:activity) }
			visit activities_path 
		end

		it { should have_title(full_title('Activities')) }
		it { should have_text('Activity Index') }
		it { should have_selector('form.navbar-form.navbar-right') }

		it "shows all activities" do
			Activity.paginate(page: 1).each do |activity|
				should have_selector('span.model-name', text: activity.name)
				should have_link 'edit', href: edit_activity_path(activity)
				should have_link 'delete', href: activity_path(activity)
			end
		end

		feature "Click delete link" do
			it { expect { click_link('delete', match: :first) }.to change(Activity, :count).by(-1) }
			feature "Success message is shown" do
				before { click_link('delete', match: :first) }
				it { should have_success_message("deleted") }
				it { should have_title(full_title("Activities")) }
			end
		end

	end

	feature "Visit Activity#new page as an admin" do
		let(:submit) { 'Create a new activity' }
		before { visit new_activity_path }

		it { should have_title(full_title('New Activity')) }
		it { should have_content('New Activity') }
		it { should have_content('Name') }
		it { should have_submit_button(submit) }

		feature "Create a new activity with invalid data" do
			before do
				fill_in "Name", with: " "
			end

			it { expect{ click_button submit }.to_not change(Activity, :count) }

			feature "The page has" do
				before { click_button submit }
				it { should have_title(full_title('New Activity')) }
				it { should have_error_message("error") }
			end
		end

		feature "Create a new activity with valid information" do
			before do 
				fill_in "Name", with: "Valid activity name"
			end

			it { expect{ click_button submit }.to change(Activity, :count).by(1) }

			feature "redirected to Activity#index page" do
				before { click_button submit }
				it { should have_title(full_title("Activities")) }
				it { should have_success_message("New activity is created!") }
			end

		end
	end

	feature "Visit Activity#edit page as an admin" do
		let(:submit) { 'Update Activity' }
		let(:activity) { FactoryGirl.create(:activity) }
		before { visit edit_activity_path(activity) }

		it { should have_title(full_title("Edit #{activity.name}")) }
		it { should have_content('Edit an activity') }
		it { should have_content('Name') }
		it { should have_submit_button(submit) }

		feature "Update with an invalid data" do
			let!(:original_name) { activity.name }
			before do
				fill_in "Name", with: " "
				click_button submit
			end

			it { expect(activity.reload.name).to eq original_name }
			it { should have_error_message("error") }
			it { should have_content('Edit an activity') }
		end

		feature "Update with a valid data" do
			let(:new_name) { "New activity" }
			before do
				fill_in "Name", with: new_name
				click_button submit
			end

			it { should have_success_message("Update is successful") }
			it { expect(activity.reload.name).to eq new_name }
			it { should have_title(full_title('Activities')) }

		end

	end
end
