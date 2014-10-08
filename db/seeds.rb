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
				access_level: "C")

#Create managers
10.times do |i|
	Employee.create(name: Faker::Name.name, 
				email: "manager#{i}@example.com", 
				position: Faker::Name.title, 
				password: "T3st0rder!", 
				password_confirmation: "T3st0rder!", 
				access_level: "B")
end

#create employees
50.times do |i|
	Employee.create(name: Faker::Name.name, 
					email: "employee_#{i}@example.com", 
					position: Faker::Name.title, 
					password: "T3st0rder!", 
					password_confirmation: "T3st0rder!", 
					access_level: "A")
end