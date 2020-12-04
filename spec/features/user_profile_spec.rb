require 'rails_helper'

RSpec.describe "Users profile page", type: :feature do
  let(:user) { FactoryBot.create :user }

  before do
    visit user_path(user)
  end

  it 'changes the current status when choosing new one' do
    select(I18n.t('user.status.working'), from: 'user[current_status]')
    find('input[type="submit"]').click
    expect(page).to have_current_path user_path(user)
    expect(page).to have_text(I18n.t('user.status.working'))
  end
end
