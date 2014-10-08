include ApplicationHelper

RSpec::Matchers.define :have_submit_button do |value|
  match do |page|
    expect(page).to have_selector("input[type=submit][value=\"#{value}\"]")
  end
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-danger', text: message)
	end
end

def log_in(user, options = {})
	   visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    check "remember_me" if options[:remember_me]
    click_button "Log in"
end