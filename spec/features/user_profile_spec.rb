require 'rails_helper'

RSpec.describe 'Users profile page', driver: :selenium_headless, js: true, type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  let(:social_account1) { FactoryBot.create :social_account }
  let(:social_account2) { FactoryBot.create :social_account }

  before do
    user.social_accounts.push(social_account1)
    user.social_accounts.push(social_account2)
    user.save
    sign_in user
    visit user_path(user)
  end

  it 'can change status by selecting item in status dropdown' do
    user.update(current_status: User.status_busy)
    target_status = User.status_free_for_chat
    find('#user_current_status').find(:option, text: I18n.t("user.status.#{target_status}")).select_option
    user.reload
    expect(user.current_status).to eq(target_status)
  end

  it 'status is editable when showing current user' do
    expect(page).to have_select('user[current_status]')
  end

  it 'status is not editable when showing different user' do
    visit user_path(user2)
    expect(page).not_to have_select('user[current_status]')
  end

  it 'contains all defined statuses' do
    expect(page).to have_select(
      'user[current_status]',
      with_options: [I18n.t('user.status.free_for_chat'), I18n.t('user.status.busy')]
    )
  end

  it 'shows current status when showing different user' do
    user2.current_status = User.status_free_for_chat
    user2.save
    visit user_path(user2)
    expect(page).to have_text(I18n.t('user.status.free_for_chat'))
  end

  it 'shows social accounts' do
    expect(page).to have_text(social_account1.social_network)
    expect(page).to have_text(social_account1.user_name)
    expect(page).to have_text(social_account2.social_network)
    expect(page).to have_text(social_account2.user_name)
  end
end
