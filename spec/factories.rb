FactoryGirl.define do
	factory :employee do
		sequence(:name) { |n| "Test_User_#{n}" } 
		sequence(:email) { |n| "testuser_#{n}@example.com" }
		position "Tester"
		password "eB^4kgL"
		password_confirmation "eB^4kgL"

		factory :admin do
			access_level "C"
		end

		factory :manager do
			access_level "B"
		end

	end


end