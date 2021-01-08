require 'rails_helper'

RSpec.describe "Homes", type: :request do
  let(:user) { FactoryBot.create :user }

  describe "GET /" do
    context 'when signed in' do
      it "returns http success" do
        sign_in user
        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when not signed in' do
      it 'returns http success' do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
