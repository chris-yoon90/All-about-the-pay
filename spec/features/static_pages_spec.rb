require 'rails_helper'

RSpec.feature "StaticPages", :type => :feature do
 	
	subject { page }

 	feature "Landing page" do
 		let(:heading) { "Keep track of your hours" }
 		let(:github_address) { "https://github.com/chris-yoon90/All-about-the-pay" }
 		before { visit root_path }
 		it { should have_title(full_title('')) }
 		it { should have_selector('h1', text: heading) }
 		it { should have_link("Help", href: help_path) }
 		it { should have_link("Log in", href: "#") }
 		it { should have_link("Github", href: github_address) }
 	end

end
