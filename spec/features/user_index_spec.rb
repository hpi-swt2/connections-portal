require 'rails_helper'

describe 'Filter users by key', type: :feature do
  let(:users) { FactoryBot.create_list(:user, 3) }
  let(:signed_in_user) { FactoryBot.create :user }

  before do
    users
    sign_in signed_in_user
  end

  context 'with a user that has no contacts and contact requests send yet' do
    before do
      visit users_path
    end

    it 'is possible to add all other users' do
      expect(page).to have_button('+', count: users.length)
    end

    it 'is not possible to see myself in the users list' do
      expect(page).not_to have_text(signed_in_user.email)
    end

    it 'does have a + button for not yet requested user' do
      users.each do |user|
        expect(page).to have_css("form[action='#{user_contact_requests_path(user)}']")
      end
    end
  end

  it 'does not have a + button for already sent contact request' do
    users.second.contact_requests << signed_in_user
    visit users_path
    expect(page).not_to have_css("form[action='#{user_contact_requests_path(users.second)}']")
  end

  it 'does not have a + button for already existing contacts' do
    signed_in_user.contacts << users.second
    visit users_path
    expect(page).to have_css("form[action='#{user_contact_requests_path(users.first)}']")
    expect(page).not_to have_css("form[action='#{user_contact_requests_path(users.second)}']")
  end

end


