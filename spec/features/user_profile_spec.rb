require 'rails_helper'

RSpec.describe "Users profile page", type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }

  before do
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
end
