require 'rails_helper'

RSpec.describe "RoomMessages", type: :request do

  let(:headers) { { ACCEPT: 'application/javascript, text/html' } }

  describe 'POST' do
    context 'when logged in' do
      before { sign_in FactoryBot.create(:user) }
      it 'returns 200' do
        post room_messages_path, params: { room_message: { room_id: 1, message: 'Test message' } }, headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not logged in' do
      it 'returns 401' do
        post room_messages_path, params: { room_message: { room_id: 1, message: 'Test message' } }, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
