require 'rails_helper'

RSpec.describe Employee, :type => :model do
  
  let(:employee) { FactoryGirl.build(:employee) }

  subject { employee }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :position }

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

end
