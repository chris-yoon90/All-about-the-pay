require 'rails_helper'

RSpec.describe Group, :type => :model do
	let(:group) { FactoryGirl.create(:group) }

	subject { group }

	it { should respond_to :name }

	describe "Group membership association" do
		let(:employee1) { FactoryGirl.create(:employee) }
		let(:employee2) { FactoryGirl.create(:employee) }

		before do
			group.accept_member!(employee1)
			group.accept_member!(employee2)
		end

		describe "When group is deleted" do
			let!(:group_memberships) { group.group_memberships.to_a } #to_a is there because it clones the group.group_memberships
			before { group.destroy }

			it "Associated group_memberships are also destroyed" do
				group_memberships.each do |group_membership|
					expect(GroupMembership.find_by(group_id: group_membership.group_id, employee_id: group_membership.employee_id)).to be_nil
				end
			end

		end

	end

	describe "Accepting Member" do
		let(:employee) { FactoryGirl.create(:employee) }
		before { group.accept_member!(employee) }
		
		specify { expect(employee.member?(group)).to be_truthy }
		its(:members) { should include(employee) }

		describe "Rejecting Member" do
			before { group.reject_member!(employee) }

			specify { expect(employee.member?(group)).to be_falsey }
			its(:members) { should_not include(employee) }
		end

	end

end
