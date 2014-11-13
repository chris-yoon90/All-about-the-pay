# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Create Site Admin
Employee.create(name: "Admin", 
				email: "admin@admin.com", 
				position: "Site Admin", 
				password: "T3st0rder!", 
				password_confirmation: "T3st0rder!",
				isAdmin: true)

#create employees
100.times do |i|
	Employee.create(name: Faker::Name.name, 
					email: "employee_#{i+1}@example.com", 
					position: Faker::Name.title, 
					password: "T3st0rder!", 
					password_confirmation: "T3st0rder!")
end

15.times do |i|
	Group.create(name: Faker::Company.name)
end

15.times do |i|
	Activity.create(name: "Activity_#{i+1}")
end

employees = Employee.all
manager1 = Employee.find(2)
manager2 = Employee.find(3)
group1 = Group.first
group2 = Group.find(2)
group3 = Group.find(3)
group1.accept_owner!(manager1)
group2.accept_owner!(manager1)
group3.accept_owner!(manager2)

group1_members = employees[4..10]
group2_members = employees[8..15]
group3_members = employees[14..30]

group1_members.each do |member|
	group1.accept_member!(member)
end

group2_members.each do |member|
	group2.accept_member!(member)
end

group3_members.each do |member|
	group3.accept_member!(member)
end
