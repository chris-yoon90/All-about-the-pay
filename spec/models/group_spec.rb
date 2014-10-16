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

	describe "Group ownership association" do
		let(:employee) { FactoryGirl.create(:employee) }

		before { group.accept_owner!(employee) }

		describe "When group is deleted" do
			let!(:group_ownership) { group.group_ownership }
			before { group.destroy }

			it "Associated group_ownership is also destroyed" do
				expect(GroupOwnership.find_by(group_id: group_ownership.group_id, employee_id: group_ownership.employee_id)).to be_nil
			end

		end
	end

	describe "Accepting a member" do
		let(:employee) { FactoryGirl.create(:employee) }
		before { group.accept_member!(employee) }
		
		specify { expect(employee.member?(group)).to be_truthy }
		its(:members) { should include(employee) }

		describe "Then rejecting a member" do
			before { group.reject_member!(employee) }

			specify { expect(employee.member?(group)).to be_falsey }
			its(:members) { should_not include(employee) }
		end
	end

	describe "Accepting the owner" do
		let(:employee) { FactoryGirl.create(:employee) }
		before { group.accept_owner!(employee) }

		specify { expect(employee.owner?(group)).to be_truthy }
		its(:owner) { should eq employee }

		describe "Then rejecting the owner" do
			before { group.reject_owner! }

			specify { expect(employee.owner?(group)).to be_falsey }
			its(:owner) { should be_nil }
		end

	end

end
