require 'rails_helper'

RSpec.describe "GroupMembershipActions", :type => :request do
  describe "As a non logged-in user" do
  	describe "Send POST request to GroupMembership#create" do
  		before { post group_memberships_path }
  		specify { expect(response).to redirect_to(login_path) }
  	end

  	describe "Send DELETE request to GroupMembership#delete" do
  		before { delete group_membership_path(1) }
  		specify { expect(response).to redirect_to(login_path) }
  	end
  end

  describe 'As a non admin user' do
  	let(:user) { FactoryGirl.create(:employee) }
  	before { log_in user, no_capybara: true }

  	describe "Send POST requeste to GroupMembership#create" do
  		before { post group_memberships_path }
  		specify { expect(response).to redirect_to(user) }
  	end

  	describe "Send DELETE request to GroupMembership#delete" do
		before { delete group_membership_path(1) }
		specify { expect(response).to redirect_to(user) }
  	end

  end

end
