require 'rails_helper'

RSpec.feature "SessionsPages", :type => :feature do
  subject { page }

  feature "log in page" do
  	before { visit login_path }

  	it { should have_title(full_title("Log in")) }
  	it { should have_selector('h2', text: "Log in") }
  	it { should have_submit_button("Log in") }

  end

end
