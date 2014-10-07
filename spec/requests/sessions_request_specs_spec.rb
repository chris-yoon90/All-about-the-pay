require 'rails_helper'

RSpec.describe "SessionsRequestSpecs", :type => :request do
  describe "Send delete request without logging in does not throw error" do
    before { delete logout_path }
    specify { expect(response).to redirect_to(login_path) }
  end
end
