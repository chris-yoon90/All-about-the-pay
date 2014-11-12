require 'rails_helper'

RSpec.describe Activity, :type => :model do
	let(:activity) { FactoryGirl.build(:activity) }

	subject { activity }

	it { should respond_to :name }

	describe "name validation" do
		it "name cannot be blank" do
			activity.name = " ";
			expect(activity.valid?).to be_falsey
		end

		it "name cannot be less than 2 characters in length" do
			activity.name = "a"
			expect(activity.valid?).to be_falsey
		end

		it "name cannot be more than 50 characters in length" do
			activity.name = "a" * 51
			expect(activity.valid?).to be_falsey
		end
	end

end
