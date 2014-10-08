require 'rails_helper'

RSpec.describe SessionsHelper do 

	let(:user) { FactoryGirl.create(:employee) }

	describe "remember(user)" do
		before { remember(user) }
		specify { expect(current_user).to eq user }

		describe "then forget(user)" do
			before { forget(user) }
			specify { expect(current_user).to eq nil }
		end

	end

end