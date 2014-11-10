require 'rails_helper'

RSpec.describe "GroupActions", :type => :request do
	let(:admin) { FactoryGirl.create(:admin) }
	before do
		log_in admin, no_capybara: true
	end

	describe 'Send GET request to Group#search_owner when the group already has an owner' do
		let(:group) { FactoryGirl.create(:group) }
		before do
			group.accept_owner!(FactoryGirl.create(:employee))
			get search_owner_group_path(group)
		end

		specify { expect(response).to redirect_to(group_path(group)) }
	end
end
