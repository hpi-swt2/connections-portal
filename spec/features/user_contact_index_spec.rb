require 'rails_helper'

describe 'Browse contacts', type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:contact) { FactoryBot.create :user }
  let(:social_account) { FactoryBot.create :social_account }

  before do
    user.contacts << contact
    user.social_accounts << social_account
    sign_in user
    visit user_contacts_path(user)
  end

  it 'shows an added contact' do
    expect(page).to have_text contact.email
    expect(page).to have_text contact.name
  end
end
