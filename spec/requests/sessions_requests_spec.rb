require 'rails_helper'

RSpec.describe "SessionsRequests", :type => :request do
  describe "Send delete request without logging in does not throw error" do
    before { delete logout_path }
    specify { expect(response).to redirect_to(login_path) }
  end

  describe "Remember me" do
  	let(:user) { FactoryGirl.create(:employee) }
  	describe "Post request with remember_me checked" do
  		before { post login_path, { email: user.email, password: user.password, remember_me: '1' } }
  		specify { expect(cookies["remember_token"]).not_to be_nil }
  	end

  	describe "Post request with remember_me unchecked" do
  		before { post login_path, { email: user.email, password: user.password } }
  		specify { expect(cookies["remember_token"]).to be_nil }
  	end

  end

end
