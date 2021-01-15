require 'rails_helper'

RSpec.describe 'Show user', type: :request do
  let(:user) { FactoryBot.create :user }

  it 'returns http success' do
    get user_path(user)
    expect(response).to have_http_status(:success)
  end
end
