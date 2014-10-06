FactoryGirl.define do
	factory :employee do
		name "Test User"
		email "testuser@example.com"
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