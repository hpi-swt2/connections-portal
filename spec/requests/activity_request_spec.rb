require 'rails_helper'

RSpec.describe 'Activities', type: :request do
  let(:headers) { { ACCEPT: 'application/javascript, text/html' } }

  describe 'POST' do
    context 'when logged in' do
      before { sign_in FactoryBot.create(:user) }

      it 'accepts new activity' do
        post activities_path, params: { activity: { content: 'Some content' } }, headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'denies an activity without content' do
        post activities_path, params: { activity: { content: nil } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when not signed in' do
      it 'redirects to the login page' do
        post activities_path, params: { activity: { content: 'Some content' } }, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
