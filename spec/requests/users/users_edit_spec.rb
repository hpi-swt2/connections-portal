require 'rails_helper'

RSpec.describe 'Edit user', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }

  context 'when signed in as appropriate user' do
    it 'returns http success' do
      sign_in user
      get edit_user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  context 'when signed in as another user' do
    it 'redirects to the root page' do
      sign_in user2
      get edit_user_path(user)
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when not signed in' do
    it 'redirects to the sign in page' do
      get edit_user_path(user)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
