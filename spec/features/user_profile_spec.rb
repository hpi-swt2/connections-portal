require 'rails_helper'

RSpec.describe "Users profile page", type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  let(:social_account1) { FactoryBot.create :social_account }
  let(:social_account2) { FactoryBot.create :social_account }

  before do
    user.social_accounts.push(social_account1)
    user.social_accounts.push(social_account2)
    user.save()
    sign_in user
    visit user_path(user)
  end

  it 'changes the current status when choosing new one' do
    select(I18n.t('user.status.working'), from: 'user[current_status]')
    find('input[type="submit"]').click
    expect(page).to have_current_path user_path(user)
    expect(page).to have_text(I18n.t('user.status.working'))
  end

  it 'status is editable when showing current user' do
    expect(page).to have_select('user[current_status]')
  end

  it 'status is not editable when showing different user' do
    visit user_path(user2)
    expect(page).not_to have_select('user[current_status]')
  end

  it 'shows current status when showing different user' do
    user2.current_status = "available"
    user2.save
    visit user_path(user2)
    expect(page).to have_text(I18n.t('user.status.available'))
  end

  it 'show social accounts' do
    expect(page).to have_text(social_account1.social_network)
    expect(page).to have_text(social_account1.user_name)
    expect(page).to have_text(social_account2.social_network)
    expect(page).to have_text(social_account2.user_name)
  end
end
