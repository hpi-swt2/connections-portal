require 'rails_helper'

describe 'Filter users by key', type: :feature do
  let(:users) { FactoryBot.create_list(:user, 3) }
  let(:signed_in_user) { FactoryBot.create :user }

  before do
    users
    sign_in signed_in_user
    visit users_path
  end

  it 'is possible to add all other users' do
    expect(page).to have_button('+', count: users.length)
  end

  it 'is not possible to see myself in the users list' do
    expect(page).not_to have_text(signed_in_user.email)
  end
end
