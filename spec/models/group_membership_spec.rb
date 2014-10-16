require 'rails_helper'

RSpec.describe GroupMembership, :type => :model do
  let(:employee) { FactoryGirl.create(:employee) }
  let(:group) { FactoryGirl.create(:group) }
  let(:membership) { group.group_memberships.build(employee_id: employee.id) }

  subject { membership }

  it { should respond_to :employee_id }
  it { should respond_to :group_id }

  its(:employee) { should eq employee }
  its(:group) { should eq group }

  it "employee_id cannot be nil" do
  	membership.employee_id = nil 
  	expect(membership.valid?).to be_falsey
  end

  it "group_id cannot be nil" do
  	membership.group_id = nil
  	expect(membership.valid?).to be_falsey
  end

end
