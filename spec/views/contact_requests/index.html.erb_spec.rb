require 'rails_helper'

RSpec.describe 'contact_requests/index', type: :view do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in FactoryBot.create(:user)
    assign(:requests, [user])
  end

  it 'renders contact requests' do
    render
    expect(rendered).to include(user.email)
  end
end
