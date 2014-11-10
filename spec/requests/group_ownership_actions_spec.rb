require 'rails_helper'

RSpec.describe "GroupOwnershipActions", :type => :request do
	describe "As a non logged-in user" do
		describe "Send POST request to GroupOwnership#create" do
			before { post group_ownerships_path }
			specify { expect(response).to redirect_to(login_path) }
		end

		describe "Send DELETE request to GroupOwnership#delete" do
			before { delete group_ownership_path(1) }
			specify { expect(response).to redirect_to(login_path) }
		end
	end

	describe 'As a non admin user' do
		let(:user) { FactoryGirl.create(:employee) }
		before { log_in user, no_capybara: true }

		describe "Send POST requeste to GroupOwnership#create" do
			before { post group_ownerships_path }
			specify { expect(response).to redirect_to(user) }
		end

		describe "Send DELETE request to GroupOwnership#delete" do
			before { delete group_ownership_path(1) }
			specify { expect(response).to redirect_to(user) }
		end
	end
end
