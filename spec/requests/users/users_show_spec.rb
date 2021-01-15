require 'rails_helper'

RSpec.describe 'Show user', type: :request do
  let(:user) { FactoryBot.create :user }

  before { sign_in user }

  it 'returns http success' do
    get user_path(user)
    expect(response).to have_http_status(:success)
  end

  context 'when signed in as another user' do
    let(:user2) { FactoryBot.create :user }

    it 'returns http success' do
      get user_path(user2)
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not signed in' do
    before { sign_out user }

    it 'redirects to the login page' do
      get user_path(user)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
