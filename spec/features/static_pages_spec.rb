require 'rails_helper'

RSpec.feature "StaticPages", :type => :feature do
 	
	subject { page }

 	feature "Landing page" do
 		let(:heading) { "Keep track of your hours" }
 		let(:github_address) { "https://github.com/chris-yoon90/PayMeNow" }
 		
 		before { visit root_path }

 		it { should have_title(full_title('')) }
 		it { should have_selector('h1', text: heading) }
 		it { should have_link("Help", href: help_path) }
 		it { should have_link("Log in", href: login_path) }
 		it { should have_link("Github", href: github_address) }
 		it { should have_link("PayMeNow", href: root_path) }

 		scenario "clicking on links should bring the user to the right places" do
 			click_link "Log in"
 			expect(page).to have_title(full_title("Log in"))
 			click_link "Help"
 			expect(page).to have_title(full_title("Help"))
 		end
 	end

end
