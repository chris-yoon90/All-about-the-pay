FactoryGirl.define do
	factory :employee do
		sequence(:name) { |n| "Test_User_#{n}" } 
		sequence(:email) { |n| "testuser_#{n}@example.com" }
		position "Tester"
		password "eB^4kgL"
		password_confirmation "eB^4kgL"

		factory :admin do
			isAdmin true
		end

	end

	factory :group do
		sequence(:name) { |n| "Test Group #{n}" }
	end

	factory :activity do
		sequence(:name) { |n| "Test Activity #{n}" }
	end

end