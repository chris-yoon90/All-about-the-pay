include ApplicationHelper

RSpec::Matchers.define :have_submit_button do |value|
  match do |page|
    expect(page).to have_selector("input[type=submit][value=\"#{value}\"]")
  end
end