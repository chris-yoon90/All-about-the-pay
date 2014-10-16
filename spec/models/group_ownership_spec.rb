require 'rails_helper'

RSpec.describe GroupOwnership, :type => :model do
	let(:group) { FactoryGirl.create(:group) }
	let(:employee) { FactoryGirl.create(:employee) }
	let(:group_ownership) { group.accept_owner!(employee) }

	subject { group_ownership }

	it { should respond_to :group_id }
	it { should respond_to :employee_id }

	its(:employee) { should eq employee }
	its(:group) { should eq group }

	describe "group_id cannot be nil" do
		before { group_ownership.group_id = nil }
		specify { expect(group_ownership.valid?).to be_falsey }
	end

	describe "employee_id cannot be nil" do
		before { group_ownership.employee_id = nil }
		specify { expect(group_ownership.valid?).to be_falsey }
	end

end
