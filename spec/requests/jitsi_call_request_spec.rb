require 'rails_helper'

RSpec.describe 'Jitsi Call', type: :request do
  describe 'POST' do
    context 'when logged in' do
      let(:participant) { FactoryBot.create(:user) }

      before { sign_in FactoryBot.create(:user) }

      it 'creates a new call' do
        post jitsi_calls_path, params: { jitsi_call: { participant_id: participant.id } }
        expect(response).to have_http_status(:no_content)
      end

      it 'does not create a new call without participant user id' do
        post jitsi_calls_path, params: { jitsi_call: { participant_id: nil } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'without logging in' do
      it 'redirects to login page' do
        post jitsi_calls_path, params: { jitsi_call: { participant_id: participant.id } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
