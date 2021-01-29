require 'rails_helper'

RSpec.describe 'List users', type: :request do
  let(:user1) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  let(:user3) { FactoryBot.create :user }

  before { sign_in user }

  it 'returns http success' do
    get users_path(user)
    expect(response).to have_http_status(:success)
    expect(response.body).to include(user.email)
  end

  context 'when not signed in' do
    before { sign_out user }

    it 'redirects to the login page' do
      get users_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
