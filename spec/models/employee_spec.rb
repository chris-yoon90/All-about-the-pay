require 'rails_helper'

RSpec.describe Employee, :type => :model do
  
  let(:employee) { FactoryGirl.build(:employee) }

  subject { employee }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :position }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :access_level }

  describe "name validation" do
  	it "name cannot be blank" do
  		employee.name = " ";
  		expect(employee.valid?).to be_falsey
  	end

  	it "name cannot be less than 2 characters in length" do
  		employee.name = "a"
  		expect(employee.valid?).to be_falsey
  	end

  	it "name cannot be more than 50 characters in length" do
  		employee.name = "a" * 51
  		expect(employee.valid?).to be_falsey
  	end
  end

  describe "email validation" do
  	it "invalid email addresses should fail validation" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
  			foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  			addresses.each do |invalid_address|
  				employee.email = invalid_address
  				expect(employee.valid?).to be_falsey
  			end
  	end

  	it "valid email addresses should pass validation" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				employee.email = valid_address
				expect(employee.valid?).to be_truthy
      end
		end

    it "email should be in lower case after save" do
      employee.email = "eXaMPLE@EXamPlE.Com"
      employee.save
      expect(employee.reload.email).to eq "example@example.com"
    end

  	it "email must be unique" do
  		employee.save
  		employee_with_same_email = employee.dup
  		expect(employee_with_same_email.valid?).to be_falsey
  	end

  end

  describe "position validation" do
  	it "position cannot be blank" do
  		employee.position = " "
  		expect(employee.valid?).to be_falsey
  	end

  	it "position cannot be less than 2 characters in length" do
  		employee.position = "a"
  		expect(employee.valid?).to be_falsey
  	end

  	it "position cannot be more than 50 characters in length" do
  		employee.position = "a" * 51
  		expect(employee.valid?).to be_falsey
  	end

  end

  describe "password" do
    it "password must be minimum of 6 characters in length" do
      password = "eM3^"
      employee.password = password
      employee.password_confirmation = password
      expect(employee.valid?).to be_falsey
    end

    it "password must have at least 1 special character or a digit" do
      password = "erMLdfg"
      employee.password = password
      employee.password_confirmation = password
      expect(employee.valid?).to be_falsey
    end

    it "password must have at least 1 lowercase alphabet" do
      password = "ERM57&^S"
      employee.password = password
      employee.password_confirmation = password
      expect(employee.valid?).to be_falsey
    end

    it "password must have at least 1 uppercase alphabet" do
      password = "erm57&^s"
      employee.password = password
      employee.password_confirmation = password
      expect(employee.valid?).to be_falsey
    end

    it "password and password_confirmation must be the same" do
      employee.password_confirmation = "jMe4&sk"
      expect(employee.valid?).to be_falsey
    end

    it "password cannot be empty" do
      password = " "
      employee.password = password
      employee.password_confirmation = password
      expect(employee.valid?).to be_falsey
    end

    it "valid passwords pass validation" do
      passwords = %w[ssssD5 ssssD^ FFFFd2 FFFFd@ 5555Ds $$$$Ds]
      passwords.each do |valid_password|
        employee.password = valid_password
        employee.password_confirmation = valid_password
        expect(employee.valid?).to be_truthy
      end
    end

  end

  describe "access_level" do
    it "access_level cannot be other than A, B or C" do
      employee.access_level = "D"
      expect(employee.valid?).to be_falsey
    end

    it "access_level defaults to A if not specified" do
      expect(employee.access_level).to eq('A')
    end

  end

  describe "When accepted as a member" do
    let(:group) { FactoryGirl.create(:group) }
    before do 
      employee.save
      group.accept_member!(employee)
    end
    
    its(:groups) { should include group }
    specify { expect(employee.member?(group)).to be_truthy }

    describe "Then rejected from the group1" do
      before { group.reject_member!(employee) }

      its(:groups) { should_not include group }
      specify { expect(employee.member?(group)).to be_falsey }

    end

  end

  describe "Group Membership association" do
    let(:group1) { FactoryGirl.create(:group) }
    let(:group2) { FactoryGirl.create(:group) }
    before do 
      employee.save
      group1.accept_member!(employee)
      group2.accept_member!(employee)
    end

    describe "When Employee is deleted" do
      let!(:group_memberships) { employee.group_memberships.to_a }
      before { employee.destroy }

      it "Associated group_memberships are also destroyed" do
        group_memberships.each do |group_membership|
          expect(GroupMembership.find_by(group_id: group_membership.group_id, employee_id: group_membership.employee_id)).to be_nil
        end
      end

    end

  end

end
