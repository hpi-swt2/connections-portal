require 'rails_helper'

RSpec.describe "Activities", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/activity/create"
      expect(response).to have_http_status(:success)
    end
  end

end
