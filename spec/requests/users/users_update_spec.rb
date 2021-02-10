require 'rails_helper'

RSpec.describe 'Update user', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  let(:attributes) { FactoryBot.attributes_for(:user) }

  context 'when signed in as appropriate user' do
    before do
      sign_in user
      patch user_path(user), params: { user: attributes }
    end

    context 'with valid params' do
      it 'redirects to the show page' do
        expect(response).to redirect_to user
      end
    end

    context 'with invalid params' do
      let(:attributes) { super().merge(username: '') }

      it 'renders the user edit page' do
        expect(response).to render_template(:edit_profile)
      end
    end
  end

  context 'when signed in as another user' do
    it 'redirects to the index page' do
      sign_in user2
      patch user_path(user), params: { user: attributes }
      expect(response).to redirect_to(users_path)
    end
  end

  context 'when not signed in' do
    it 'redirects to the login page' do
      patch user_path(user), params: { user: attributes }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
