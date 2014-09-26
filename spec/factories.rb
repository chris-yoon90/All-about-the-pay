FactoryGirl.define do
	factory :employee do
		name "Test User"
		email "testuser@example.com"
		position "Tester"
		password "eB^4kgL"
		password_confirmation "eB^4kgL"
	end
end