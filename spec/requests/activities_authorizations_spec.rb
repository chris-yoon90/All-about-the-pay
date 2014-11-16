require 'rails_helper'

RSpec.describe "ActivitiesAuthorizations", :type => :request do
	describe "As a non-logged in user" do
		describe "Send a GET request to Activities#index" do
			before { get activities_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send a GET request to Activities#new" do
			before { get new_activity_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send a POST request to Activities#create" do
			before { post activities_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send a DELETE request to Activities#destroy" do
			before { delete activity_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send a GET request to Activities#edit" do
			before { get edit_activity_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send a PUT/PATCH request to Activities#edit" do
			before { patch activity_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end
	end

	describe "As non-admin user" do
		let(:non_admin_user) { FactoryGirl.create(:employee) }
		before { log_in non_admin_user, no_capybara: true }

		describe "Send a GET request to Activities#index" do
			before { get activities_path }
			specify { expect(response).to redirect_to(non_admin_user) }
		end

		describe "Send a GET request to Activities#new" do
			before { get new_activity_path }
			specify { expect(response).to redirect_to(non_admin_user) }
		end

		describe "Send a POST request to Activities#create" do
			before { post activities_path }
			specify { expect(response).to redirect_to(non_admin_user) }
		end

		describe "Send a DELETE request to Activities#destroy" do
			before { delete activity_path(1) }
			specify { expect(response).to redirect_to(non_admin_user) }
		end

		describe "Send a GET request to Activities#edit" do
			before { get edit_activity_path(1) }
			specify { expect(response).to redirect_to(non_admin_user) }
		end

		describe "Send a PUT/PATCH request to Activities#edit" do
			before { patch activity_path(1) }
			specify { expect(response).to redirect_to(non_admin_user) }
		end

	end

end
