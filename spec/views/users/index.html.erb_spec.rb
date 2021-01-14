require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:users) { FactoryBot.create_list(:user, 3) }

  before do
    assign(:users, users)
    sign_in users.first
    render
  end

  it 'renders a list of users' do
    users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it 'has an + button to add a contact' do
    expect(rendered).to have_button('+', count: users.length)
  end
end
