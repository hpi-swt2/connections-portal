require 'rails_helper'

RSpec.describe "Update user status", type: :request do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  let(:status_params) { { user: { current_status: 'working' } } }

  context 'when signed in as appropriate user' do
    it "redirects to the show page" do
      sign_in user
      patch update_status_user_path(user), params: status_params
      expect(response).to redirect_to(user_path(user))
    end
  end

  context 'when signed in as another user' do
    it "redirects to the root page" do
      sign_in user2
      patch update_status_user_path(user), params: status_params
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when not signed in' do
    it 'redirects to the sign in page' do
      patch update_status_user_path(user), params: status_params
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
