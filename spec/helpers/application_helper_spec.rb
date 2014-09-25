require 'rails_helper'

RSpec.describe ApplicationHelper do 
	describe "full_title" do
		it "should include the page title" do
			expect(full_title("foo")).to match(/foo/)
		end

		it "should include th base title" do
			expect(full_title("foo")).to match(/^All-About-The-Pay/)
		end

		it "should not include a bar for the home page" do
			expect(full_title("")).not_to match(/\|/)
		end
	end
end